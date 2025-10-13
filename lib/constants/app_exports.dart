export 'package:flutter/material.dart';
export 'package:go_router/go_router.dart';
export 'package:google_fonts/google_fonts.dart';

//SCREENS
export '/screens/dashboard_screen.dart';
export '/screens/expenses_screen.dart';
export '/screens/inventory_screen.dart';
export '/screens/calendar_screen.dart';
export '/screens/housekeeping_screen.dart';
export '/screens/notifications_screen.dart';
export '/screens/settings_screen.dart';

//GENERAL WIDGETS
export '/widgets/general_widgets/gradient_background.dart'; //REUSABLE GRADIENT BACKGROUND
export '/widgets/general_widgets/responsive_card_grid.dart'; //CONTAINER FOR SUMMARY CARD
export '/widgets/general_widgets/summary_card.dart'; //SUMMARY CARDS
export '/widgets/general_widgets/navigation.dart'; //NAVIGATION BAR
export '/widgets/general_widgets/reusable_card.dart'; //USED FOR UPCOMING BOOKINGS COULD BE GENERIC (CALENDAR)

//FROM DASHBOARD
export '/widgets/dashboard/recent_activity_card.dart'; //RECENT ACTIVITY CARD
export '/widgets/dashboard/activity_item.dart'; //ACTIVITY ITEM FOR RECENT ACTIVITY CARD

//FROM EXPENSES
export '/widgets/expenses/expense_item_card.dart'; //VARIABLE EXPENSES
export '/widgets/expenses/expense_section_card.dart'; //VARIABLE EXPENSES CARD

//FROM INVENTORY
export '/widgets/inventory/custom_tab_bar.dart'; //CUSTOM TAB BAR FOR CLEANING, WASHABLES, TOILETRIES
export '/widgets/inventory/status_indicators.dart'; //STATUS INDICATORS = GOOD, LOW, CRITICAL
export '/widgets/inventory/restock_alert.dart'; //RESTOCK ALERT = NEED TO RESTOCK CARD
export '/widgets/inventory/inventory_item_card.dart'; //INVENTORY ITEM CARD
export '/widgets/inventory/section_header_with_action.dart'; //TITLE WITH ADD ITEM BUTTON

//GENERIC DIALOGS
export '/widgets/generic_dialogs/generic_form_dialog.dart'; //GENERIC FORM DIALOG COMPONENT
export '/widgets/generic_dialogs/dialog_configurations.dart'; //DIALOG CONFIGURATION HELPERS

//FROM CALENDAR
export '/widgets/calendar/calendar_legend.dart';
export '/widgets/calendar/booking_detail_row.dart';
export '/widgets/calendar/status_badge.dart'; //STATUS BADGE = CONFIRMED, PENDING, CANCELLED
export '/widgets/calendar/booking_card.dart'; //BOOKING CARD INSIDE UPCOMING BOOKINGS
export '/widgets/calendar/action_button.dart'; //SYNC BUTTON
export '/widgets/calendar/calendar_import_dialog.dart'; //MAIN CALENDAR IMPORT DIALOG
export '/widgets/calendar/dialog_header.dart'; //DIALOG HEADER COMPONENT
export '/widgets/calendar/dialog_footer.dart'; //DIALOG FOOTER COMPONENT
export '/widgets/calendar/platform_card.dart'; //PLATFORM CARD COMPONENT
export '/widgets/calendar/custom_calendar_section.dart'; //CUSTOM CALENDAR SECTION
export '/widgets/calendar/import_result_message.dart'; //RESULT MESSAGE COMPONENT
export '/widgets/calendar/sample_url_dialog.dart'; //SAMPLE URL DIALOG


//FROM ANALYTICS
export '/widgets/analytics/chart_container.dart'; 
export '/widgets/analytics/revenue_line_chart.dart';
export '/widgets/analytics/booking_sources_pie_chart.dart';
export '/widgets/analytics/responsive_charts_layout.dart'; //CONTAINER FOR CHART CONTAINER

//FROM NOTIFICATIONS
export '../widgets/notifications/notification_card.dart';
export '../widgets/notifications/notification_icon.dart';
export '../widgets/notifications/priority_badge.dart'; //PRIORITY BADGE = HIGH, MEDIUM, LOW
export '../widgets/notifications/notification_actions.dart'; //MARK ALL READ, SETTINGS BUTTON
export '../widgets/notifications/notification_list_header.dart'; //HEADER THAT CONTAINS NOTIFICATION TITLE AND ACTIONS

//FROM SETTINGS
export '/widgets/settings/settings_card.dart'; //SETTINGS CARD WRAPPER
export '/widgets/settings/settings_switch_tile.dart'; //SWITCH TILE FOR SETTINGS
export '/widgets/settings/platform_tile.dart'; //PLATFORM INTEGRATION TILE
export '/widgets/settings/settings_input_field.dart'; //TEXT BOX IN APP PREFERENCES
export '/widgets/settings/settings_dropdown_field.dart'; //DROPDOWN FIELD IN APP PREFERENCES
export '/widgets/settings/settings_section.dart'; //SETTINGS SECTION WITH SPACING

//FROM HOUSEKEEPING
export '/constants/housekeeping_helpers.dart'; //HOUSEKEEPING COLOR AND ICON HELPERS

export '/widgets/housekeeping/tab_navigation.dart'; //REUSABLE TAB NAVIGATION
export '/widgets/housekeeping/status_chip.dart'; //REUSABLE STATUS CHIP
export '/widgets/housekeeping/info_row.dart'; //REUSABLE INFO ROW
export '/widgets/housekeeping/task_card.dart'; //REUSABLE TASK CARD
export '/widgets/housekeeping/staff_card.dart'; //REUSABLE STAFF CARD
export '/widgets/housekeeping/staff_schedule_dialog.dart'; //STAFF SCHEDULE DIALOG
export '/widgets/housekeeping/task_badges.dart'; //TASK TYPE BADGES

export '/screens/housekeeping/tasks_tab.dart';
export '/screens/housekeeping/staff_tab.dart';

//CONSTANTS
export '/constants/app_constants.dart';
export '/constants/app_routes.dart'; //APP ROUTES CONFIGURATION
export '/constants/schedule_utils.dart'; //SCHEDULE UTILITIES

//MODELS
export '/models/notification_model.dart';

//SERVICES
export '/services/supabase_service.dart';
export '/services/dashboard_service.dart';
export '/services/expenses_service.dart';
export '/services/inventory_service.dart';
export '/services/calendar_service.dart';
export '/services/calendar_import_service.dart';
export '/services/housekeeping_service.dart';
export '/services/notifications_service.dart';
export '/services/data_export_service.dart';