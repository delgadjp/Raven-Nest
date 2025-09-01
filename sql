-- =====================================
-- EXTENSIONS
-- =====================================
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- =====================================
-- BOOKINGS TABLE
-- =====================================
CREATE TABLE public.bookings (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    source text,
    guest_name text,
    room_number text,
    check_in date,
    check_out date,
    status text DEFAULT 'pending', -- pending, confirmed, cancelled
    total_amount numeric(10,2),
    created_at timestamp with time zone DEFAULT now()
);
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

-- =========================
-- EXPENSES TABLE
-- =========================
CREATE TABLE public.expenses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id uuid REFERENCES public.bookings(id) ON DELETE SET NULL,
    name text,
    amount numeric(10,2),
    category text,
    date date,
    month int,
    year int,
    created_at timestamp with time zone DEFAULT now()
);
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
CREATE INDEX idx_expenses_booking_id ON public.expenses (booking_id);

-- =====================================
-- REVENUE TABLE (Per-booking tracking)
-- =====================================
CREATE TABLE public.revenue (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id uuid REFERENCES public.bookings(id) ON DELETE CASCADE,
    expense_id uuid REFERENCES public.expenses(id) ON DELETE SET NULL,
    income numeric(10,2) DEFAULT 0.00,
    expense numeric(10,2) DEFAULT 0.00,
    net_income numeric(10,2) GENERATED ALWAYS AS (COALESCE(income,0) - COALESCE(expense,0)) STORED,
    month int,
    year int,
    created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.revenue ENABLE ROW LEVEL SECURITY;

-- =====================================
-- TRIGGERS: Auto-populate revenue from bookings
-- =====================================
CREATE OR REPLACE FUNCTION public.add_booking_revenue()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.revenue (booking_id, income, month, year)
    VALUES (
        NEW.id,
        NEW.total_amount,
        EXTRACT(MONTH FROM NEW.created_at)::int,
        EXTRACT(YEAR FROM NEW.created_at)::int
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_add_booking_revenue
AFTER INSERT ON public.bookings
FOR EACH ROW
EXECUTE FUNCTION public.add_booking_revenue();

-- =====================================
-- TRIGGERS: Auto-populate revenue from expenses
-- =====================================
CREATE OR REPLACE FUNCTION public.add_expense_revenue()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.revenue (booking_id, expense_id, expense, month, year)
    VALUES (
        NEW.booking_id,
        NEW.id,
        NEW.amount,
        NEW.month,
        NEW.year
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_add_expense_revenue
AFTER INSERT ON public.expenses
FOR EACH ROW
EXECUTE FUNCTION public.add_expense_revenue();

-- =====================================
-- INVENTORY CATEGORIES
-- =====================================
CREATE TABLE public.inventory_categories (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text,
    created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.inventory_categories ENABLE ROW LEVEL SECURITY;

-- =====================================
-- INVENTORY ITEMS
-- =====================================
CREATE TABLE public.inventory_items (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id uuid NOT NULL REFERENCES public.inventory_categories(id) ON DELETE RESTRICT,
    name text,
    unit text,
    current_stock int,
    min_stock int,
    created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.inventory_items ENABLE ROW LEVEL SECURITY;
CREATE INDEX idx_inventory_items_category_id ON public.inventory_items (category_id);

-- =====================================
-- HOUSEKEEPING STAFF
-- =====================================
CREATE TABLE public.housekeeping_staff (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text,
    contact text,
    email text,
    created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.housekeeping_staff ENABLE ROW LEVEL SECURITY;

-- =====================================
-- HOUSEKEEPING TASKS
-- =====================================
CREATE TABLE public.housekeeping_tasks (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    room_number text,
    task_type text,
    assigned_staff uuid NOT NULL REFERENCES public.housekeeping_staff(id) ON DELETE RESTRICT,
    due_date date,
    due_time time,
    priority text,
    priority_weight int DEFAULT 3 CHECK(priority_weight BETWEEN 1 AND 5),
    status text,
    created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.housekeeping_tasks ENABLE ROW LEVEL SECURITY;
CREATE INDEX idx_housekeeping_tasks_assigned_staff ON public.housekeeping_tasks (assigned_staff);
CREATE INDEX idx_housekeeping_tasks_priority_weight ON public.housekeeping_tasks (priority_weight);

-- =====================================
-- NOTIFICATIONS
-- =====================================
CREATE TABLE public.notifications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    type text,
    title text,
    message text,
    priority text,
    is_read boolean DEFAULT false,
    related_booking uuid REFERENCES public.bookings(id) ON DELETE SET NULL,
    related_task uuid REFERENCES public.housekeeping_tasks(id) ON DELETE SET NULL,
    related_item uuid REFERENCES public.inventory_items(id) ON DELETE SET NULL,
    created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
CREATE INDEX idx_notifications_booking ON public.notifications (related_booking);
CREATE INDEX idx_notifications_task ON public.notifications (related_task);
CREATE INDEX idx_notifications_item ON public.notifications (related_item);
