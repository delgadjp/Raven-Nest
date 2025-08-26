export 'package:flutter/material.dart';


//GENERAL WIDGETS
export '/widgets/responsive_card_grid.dart'; //CONTAINER FOR SUMMARY CARD
export '/widgets/summary_card.dart'; //SUMMARY CARDS
export '/widgets/navigation.dart'; //NAVIGATION BAR
export '/widgets/reusable_card.dart'; //USED FOR UPCOMING BOOKINGS COULD BE GENERIC (CALENDAR)

//FROM DASHBOARD
export '/widgets/quick_action_card.dart'; //QUICK ACTION CARD
export '/widgets/recent_activity_card.dart'; //RECENT ACTIVITY CARD
export '/widgets/activity_item.dart'; //ACTIVITY ITEM FOR RECENT ACTIVITY CARD

//FROM EXPENSES
export '/widgets/add_expense_dialog.dart'; //ADD VARIABLE EXPENSES
export '/widgets/expense_item_card.dart'; //VARIABLE EXPENSES
export '/widgets/expense_section_card.dart'; //VARIABLE EXPENSES CARD
export '/widgets/gradient_total_card.dart'; //MONTHLY TOTAL CARD

//FROM INVENTORY
export '/widgets/custom_tab_bar.dart'; //CUSTOM TAB BAR FOR CLEANING, WASHABLES, TOILETRIES
export '/widgets/status_indicators.dart'; //STATUS INDICATORS = GOOD, LOW, CRITICAL
export '/widgets/restock_alert.dart'; //RESTOCK ALERT = NEED TO RESTOCK CARD
export '/widgets/inventory_item_card.dart'; //INVENTORY ITEM CARD
export '/widgets/section_header_with_action.dart'; //TITLE WITH ADD ITEM BUTTON

//FROM CALENDAR
export '/widgets/calendar_legend.dart';
export '/widgets/booking_detail_row.dart';
export '/widgets/status_badge.dart'; //STATUS BADGE = CONFIRMED, PENDING, CANCELLED
export '/widgets/booking_card.dart'; //BOOKING CARD INSIDE UPCOMING BOOKINGS
export '/widgets/action_button.dart'; //SYNC BUTTON

//FROM ANALYTICS
export '/widgets/chart_container.dart'; 
export '/widgets/revenue_line_chart.dart';
export '/widgets/booking_sources_pie_chart.dart';
export '/widgets/responsive_charts_layout.dart'; //CONTAINER FOR CHART CONTAINER

//FROM NOTIFICATIONS
export '/widgets/notification_card.dart';
export '/widgets/notification_icon.dart';
export '/widgets/priority_badge.dart'; //PRIORITY BADGE = HIGH, MEDIUM, LOW
export '/widgets/notification_actions.dart'; //MARK ALL READ, SETTINGS BUTTON
export '/widgets/notification_list_header.dart'; //HEADER THAT CONTAINS NOTIFICATION TITLE AND ACTIONS

//FROM SETTINGS
export '/widgets/settings_card.dart'; //SETTINGS CARD WRAPPER
export '/widgets/settings_switch_tile.dart'; //SWITCH TILE FOR SETTINGS
export '/widgets/platform_tile.dart'; //PLATFORM INTEGRATION TILE
export '/widgets/settings_input_field.dart'; //TEXT BOX IN APP PREFERENCES
export '/widgets/settings_section.dart'; //SETTINGS SECTION WITH SPACING

//FROM HOUSEKEEPING
export '/constants/housekeeping_helpers.dart'; //HOUSEKEEPING COLOR AND ICON HELPERS

export '/widgets/tab_navigation.dart'; //REUSABLE TAB NAVIGATION
export '/widgets/status_chip.dart'; //REUSABLE STATUS CHIP
export '/widgets/info_row.dart'; //REUSABLE INFO ROW
export '/widgets/task_card.dart'; //REUSABLE TASK CARD
export '/widgets/staff_card.dart'; //REUSABLE STAFF CARD

export '/screens/housekeeping/tasks_tab.dart';
export '/screens/housekeeping/staff_tab.dart';

//CONSTANTS
export '/constants/app_constants.dart';


//MODELS
export '/models/notification_model.dart';