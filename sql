CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE public.bookings (
    id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    source        text,
    guest_name    text,
    room_number   text,               -- optional
    check_in      date,
    check_out    date,
    status        text,               -- confirmed, cancelled, completed
    total_amount  numeric,
    created_at    timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.expenses (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name        text,
    amount      numeric,
    category    text,                -- fixed or variable
    month       integer CHECK (month BETWEEN 1 AND 12),
    year        integer,
    date        date,
    booking_id  uuid,
    created_at  timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT fk_expenses_booking
        FOREIGN KEY (booking_id)
        REFERENCES public.bookings (id)
        ON DELETE SET NULL
);
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
CREATE INDEX idx_expenses_booking_id ON public.expenses (booking_id);

CREATE TABLE public.revenue (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id  uuid NOT NULL,
    month       integer CHECK (month BETWEEN 1 AND 12),
    year        integer,
    amount      numeric,
    created_at  timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT fk_revenue_booking
        FOREIGN KEY (booking_id)
        REFERENCES public.bookings (id)
        ON DELETE CASCADE
);
ALTER TABLE public.revenue ENABLE ROW LEVEL SECURITY;
CREATE INDEX idx_revenue_booking_id ON public.revenue (booking_id);

CREATE TABLE public.inventory_categories (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name        text,
    created_at  timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.inventory_categories ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.inventory_items (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id uuid NOT NULL,
    name        text,
    unit        text,               -- pcs, packs, liters, …
    current_stock integer,
    min_stock     integer,
    created_at   timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT fk_inventory_category
        FOREIGN KEY (category_id)
        REFERENCES public.inventory_categories (id)
        ON DELETE RESTRICT
);
ALTER TABLE public.inventory_items ENABLE ROW LEVEL SECURITY;
CREATE INDEX idx_inventory_items_category_id ON public.inventory_items (category_id);

CREATE TABLE public.housekeeping_staff (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name        text,
    contact     text,
    email       text,
    created_at  timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.housekeeping_staff ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.housekeeping_tasks (
    id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    room_number   text,
    task_type     text,                -- checkout cleaning, etc.
    assigned_staff uuid NOT NULL,
    due_date      date,
    due_time      time,
    priority      text,                -- low, medium, high
    status        text,                -- pending, upcoming, completed
    created_at    timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT fk_task_staff
        FOREIGN KEY (assigned_staff)
        REFERENCES public.housekeeping_staff (id)
        ON DELETE RESTRICT
);
ALTER TABLE public.housekeeping_tasks ENABLE ROW LEVEL SECURITY;
CREATE INDEX idx_housekeeping_tasks_assigned_staff ON public.housekeeping_tasks (assigned_staff);

CREATE TABLE public.notifications (
    id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    type             text,               -- booking, housekeeping, inventory, system
    title            text,
    message          text,
    priority         text,               -- low, medium, high
    is_read          boolean DEFAULT false,
    related_booking  uuid,
    related_task     uuid,
    related_item     uuid,
    created_at       timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT fk_notif_booking
        FOREIGN KEY (related_booking)
        REFERENCES public.bookings (id)
        ON DELETE SET NULL,
    CONSTRAINT fk_notif_task
        FOREIGN KEY (related_task)
        REFERENCES public.housekeeping_tasks (id)
        ON DELETE SET NULL,
    CONSTRAINT fk_notif_item
        FOREIGN KEY (related_item)
        REFERENCES public.inventory_items (id)
        ON DELETE SET NULL
);
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
CREATE INDEX idx_notifications_booking ON public.notifications (related_booking);
CREATE INDEX idx_notifications_task    ON public.notifications (related_task);
CREATE INDEX idx_notifications_item    ON public.notifications (related_item);