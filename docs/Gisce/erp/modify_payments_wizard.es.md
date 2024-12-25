# Asistente Modificar Pagos (Modify Payments)

- [Donde lo encuentro](#donde-lo-encuentro)
- [Como utilizarlo](#como-utilizarlo)
  - [Seleccionar pago a modificar](#seleccionar-pago-a-modificar)
  - [Modificar Pago](#modificar-pago)
    - [Deshacer movimiento](#deshacer-movimiento)
    - [Modificar fecha](#modificar-fecha)
    - [Modificar diario](#modificar-diario)

## Donde lo encuentro

Este asistente se encuentra en el menu de asistentes (rayito) en la opcion que se llama `"Modify Payments"`, dentro de una factura de luz.\
![wizard_selector]

## Como utilizarlo

![wizard_opening_view]

### Seleccionar pago a modificar

Primero del todo utilizaremos la lupa arriba a la derecha para seleccionar el pago a modificar:\
![wizard_opening_view_magnifying_glass]

Esto nos abrira un buscador de los pagos relacionados con la factura y si lo seleccionamos lo veremos en los asistentes:\
![wizard_search_for_payment]

![wizard_modify_payments_base_view_payment_selected]

### Modificar Pago

![wizard_modify_payments_mid_view_buttons]

#### Deshacer movimiento

Para deshacer el movimiento, nos va a pedir una fecha desde la cual se va a hacer efectivo el cambio que no es obligatoria. Una vez hecho esto si le damos al boton de deshacer, se procedera a deshacer el pago y veremos una confirmacion:\
![wizard_modify_payments_undo_view]

![wizard_modify_payments_done_view]

#### Modificar fecha

Con esta opcion podremos modificar la fecha en la cual se hizo el pago:\
![wizard_modify_payments_date_view]

Por ejemplo hemos pasado del dia 23/07/2024 a 10/07/2024:

- Original (23/07/2024):\
  ![payment_line_date_original]
- Modificat (10/07/2024):\
  ![payment_line_date_modified]

#### Modificar diario

[wizard_selector]:/gisce_data/erp/modify_payments_wizard/wizards_selector.png
[wizard_opening_view]:/gisce_data/erp/modify_payments_wizard/wizard_modify_payments_init_view.png
[wizard_opening_view_magnifying_glass]:/gisce_data/erp/modify_payments_wizard/wizard_modify_payments_init_view_emphasis_on_magnifying_glass.png
[wizard_search_for_payment]:/gisce_data/erp/modify_payments_wizard/wizard_modify_payments_search_for_payment.png
[wizard_modify_payments_base_view_payment_selected]:/gisce_data/erp/modify_payments_wizard/wizard_modify_payments_init_view_payment_selected.png
[wizard_modify_payments_mid_view_buttons]:/gisce_data/erp/modify_payments_wizard/wizard_modify_payments_mid_view_buttons.png
[wizard_modify_payments_undo_view]:/gisce_data/erp/modify_payments_wizard/wizard_modify_payments_undo_state_view.png
[wizard_modify_payments_done_view]:/gisce_data/erp/modify_payments_wizard/wizard_modify_payments_done_state_view.png
[wizard_modify_payments_date_view]:/gisce_data/erp/modify_payments_wizard/wizard_modify_payments_date_state_view.png
[payment_line_date_original]:/gisce_data/erp/modify_payments_wizard/payment_line_date_230724.png
[payment_line_date_modified]:/gisce_data/erp/modify_payments_wizard/payment_line_date_100724.png
