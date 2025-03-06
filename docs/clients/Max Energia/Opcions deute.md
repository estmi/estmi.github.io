# Opcions deute

## Opcio Facturacio -> General -> Facturas Cliente -> Facturas Cliente con deuda
Domain: [('type', '=', 'out_invoice'), ('invoice_id.pending_state.weight', '>', 0)]
Context: 'active_test': False

Aparecen todas las facturas emitidas con estado pendiente.

## [IMPAGOS_MAX] Facturas Cliente con deuda (Electricidad) - Dashboard

Facturas emitidas y abonadoras emitidas, que no estan en "Proceso Pago", son facturas en estado "abierto", la fecha de vencimiento tiene que ser anterior o igual al ultimo domingo, esta semana no esta incluida. En caso de ser de Baleares, tener cnae 9499 y de tener el estado "abierto", apareceran solo a partir de 60 dias a partir del ultimo domingo.

