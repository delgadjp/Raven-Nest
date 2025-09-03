-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.booking_sources (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  description text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT booking_sources_pkey PRIMARY KEY (id)
);
CREATE TABLE public.bookings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  check_in date,
  check_out date,
  status USER-DEFINED DEFAULT 'pending'::booking_status,
  total_amount numeric,
  created_at timestamp with time zone DEFAULT now(),
  source_id uuid,
  CONSTRAINT bookings_pkey PRIMARY KEY (id),
  CONSTRAINT bookings_source_id_fkey FOREIGN KEY (source_id) REFERENCES public.booking_sources(id)
);
CREATE TABLE public.expenses (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  booking_id uuid,
  name text,
  amount numeric,
  category text,
  date date,
  month integer,
  year integer,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT expenses_pkey PRIMARY KEY (id),
  CONSTRAINT expenses_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id)
);
CREATE TABLE public.housekeeping_staff (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text,
  contact text,
  email text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT housekeeping_staff_pkey PRIMARY KEY (id)
);
CREATE TABLE public.housekeeping_tasks (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_number text,
  task_type text,
  assigned_staff uuid NOT NULL,
  due_date date,
  due_time time without time zone,
  priority text,
  priority_weight integer DEFAULT 3 CHECK (priority_weight >= 1 AND priority_weight <= 5),
  status USER-DEFINED DEFAULT 'pending'::housekeeping_task_status,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT housekeeping_tasks_pkey PRIMARY KEY (id),
  CONSTRAINT housekeeping_tasks_assigned_staff_fkey FOREIGN KEY (assigned_staff) REFERENCES public.housekeeping_staff(id)
);
CREATE TABLE public.inventory_categories (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT inventory_categories_pkey PRIMARY KEY (id)
);
CREATE TABLE public.inventory_items (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  category_id uuid NOT NULL,
  name text,
  unit text,
  current_stock integer,
  min_stock integer,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT inventory_items_pkey PRIMARY KEY (id),
  CONSTRAINT inventory_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.inventory_categories(id)
);
CREATE TABLE public.notifications (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  type text,
  title text,
  message text,
  priority USER-DEFINED DEFAULT 'medium'::notification_priority,
  is_read boolean DEFAULT false,
  related_booking uuid,
  related_task uuid,
  related_item uuid,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT notifications_pkey PRIMARY KEY (id),
  CONSTRAINT notifications_related_task_fkey FOREIGN KEY (related_task) REFERENCES public.housekeeping_tasks(id),
  CONSTRAINT notifications_related_booking_fkey FOREIGN KEY (related_booking) REFERENCES public.bookings(id),
  CONSTRAINT notifications_related_item_fkey FOREIGN KEY (related_item) REFERENCES public.inventory_items(id)
);
CREATE TABLE public.revenue (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  booking_id uuid,
  expense_id uuid,
  income numeric DEFAULT 0.00,
  expense numeric DEFAULT 0.00,
  net_income numeric DEFAULT (COALESCE(income, (0)::numeric) - COALESCE(expense, (0)::numeric)),
  month integer,
  year integer,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT revenue_pkey PRIMARY KEY (id),
  CONSTRAINT revenue_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id),
  CONSTRAINT revenue_expense_id_fkey FOREIGN KEY (expense_id) REFERENCES public.expenses(id)
);