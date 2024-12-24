# Modificar linia de descompte de Bateria Virtual en cas de factura sense IESE

## Reduir import de la linia de descompte sde la factura sobre bateria virtual

Primer revisarem quin import necessitem modificar, en el cas actual, necessitem reduir 0.18 €:

![totals_factura]

Ara agafarem la `Linia de Descompte Bateria Virtual` i li reduirem l'import de -4.68 € a -4.50 €.

![invoice_lines_old_price]

![invoice_line_discount_old_price]

![invoice_line_discount_new_price]

Al modificar el preu de la linia i guardar, veurem que s'actualitzen els totals donant-nos 0 €.

![total_factura_nou]

## Reduir import linia extra

Dintre de la polissa anirem a related i a `Extra lines`:

![related_menu_extra_lines]

Un cop tenim la factura arreglada, el que hem de revisar son les linies extra, en aquest cas, hem de agafar la linia extra que s'ha creat per fer la linia de descompte i reduir-ne l'import:

![extra_line_old_price]

![extra_line_new_price]

## Reduir import descomptat als descomptes de bateria virtual

Finalment hem de reduir el que s'ha descomptat de la bateria virtual:

Anirem a l'apartat de `Bateries Virtuals` de la polissa i a la bateria virtual afectada entrarem a relacionats i seleccionarem `Descomptes de la Bateria Virtual`:

![related_bateria_virtual]

Despres seleccionarem el descompte que ens afecta, i li restarem la part de iese, en aquest cas els 18c.

![bateria_virtual_discounts_list]

![bateria_virtual_discount_old_price]

![bateria_virtual_discount_new_price]

[totals_factura]: /clients/modify_virtual_batery_line_in_fact/total_detail_invoiced.png
[invoice_lines_old_price]: /clients/modify_virtual_batery_line_in_fact/invoice_lines_bat_virt_selected.png
[invoice_line_discount_old_price]: /clients/modify_virtual_batery_line_in_fact/bat_virt_invoice_line_form_old_price.png
[invoice_line_discount_new_price]: /clients/modify_virtual_batery_line_in_fact/bat_virt_invoice_line_form_new_price.png
[total_factura_nou]: /clients/modify_virtual_batery_line_in_fact/total_detail_invoiced_new_price.png
[extra_line_old_price]: /clients/modify_virtual_batery_line_in_fact/extra_line_old_price.png
[extra_line_new_price]: /clients/modify_virtual_batery_line_in_fact/extra_line_new_price.png
[related_menu_extra_lines]: /clients/modify_virtual_batery_line_in_fact/related_menu_extra_lines.png
[related_bateria_virtual]: /clients/modify_virtual_batery_line_in_fact/related_bateria_virtual.png
[bateria_virtual_discounts_list]: /clients/modify_virtual_batery_line_in_fact/bateria_virtual_discounts_list.png
[bateria_virtual_discount_old_price]: /clients/modify_virtual_batery_line_in_fact/bateria_virtaul_discount_old_price.png
[bateria_virtual_discount_new_price]: /clients/modify_virtual_batery_line_in_fact/bateria_virtaul_discount_new_price.png
