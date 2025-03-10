# Canvi de titular

## ATR

Els canvis de titular es duen a terme a través de processos ATR, més en concret els M1, on nosaltres generarem un M1-01 per sol·licitar el canvi i després rebrem un M1-02 de confirmació i un M1-05 d'activació.

## Crear cas ATR

Per generar qualsevol cas ATR utilitzarem l'assistent de la pòlissa `Generar Cas Gestió ATR`, aquest assistent té aquesta cara:

![wizard_create_atr]

## Generar M1

Per crear un M1, triarem l'opció desitjada de l'assistent, `M1 - Modificació contractual`, i amb això veurem un nou assistent on podrem configurar diversos canvis que s'han de notificar a la distribuïdora, com per exemple el canvi de titular:

![wizard_create_atr_m1]

## Pas 01: Configurar M1 per canvi de titular

Per fer un canvi de titular desmarcarem el check de `Canvi Tarifa/Potencia` a la part superior i marcarem el de `Canvi Titular`, fent això ens desapareixeran tota una sèrie de camps que no tenen relació amb el canvi de titular i s'habilitaran els del canvi de titular:

![wizard_create_atr_m1_canvi_titular]

### Camps i descripcio

#### Contracte Nou

![wizard_create_atr_m1_contracte_nou]

Aquesta opció ens permet definir quin contracte serà el nou contracte, permetent-nos generar d'avantmà el contracte ben configurat i aquí estipular-lo, o podem especificar-li que volem generar un nou contracte en esborrany. [^generacio_contracte_m1]

Si utilitzem l'opció de `Utilitzar contracte existent`, només haurem de validar que les dades de l'assistent són correctes, fins i tot ens detectarà el contracte nou en esborrany de forma automàtica. D'altra banda, si escollim `Crear nou contracte en borrador` haurem d'especificar tots els camps sol·licitats, cosa que al final en generar el cas atr també crearà la pòlissa en esborrany.

#### Titular

![wizard_create_atr_m1_titular]

- `Tipus de canvi`: Aquí trobarem diverses opcions d'un M1 de canvis administratius, pero en un canvi de titular ens interessen les 2 següents:
  - `Cambio de titular por subrogación`: Aquesta opció només farà una modificació contractual[^nova_polissa_segons_variable] de canvi de titular fent que el nou titular "heredi" els possibles deutes o beneficis del titular anterior.
  - `Cambio de titular por traspaso`: Aquesta opció és per marcar que es farà una pòlissa completament nova i independent.
- `Tipus de document`: Tipus de document d'identitat del nou titular.
- `Número de Document`
- `Nou Titular`: Seleccionar nou titular, s'ha de tenir creat abans d'aquest punt.

#### Contacte

![wizard_create_atr_m1_contacte]

Definirem les dades de contacte del titular, per això tindrem un partner/empresa una adreça de notificació del partner i també en definirem el nom[^nom_contacte] i telèfon.

#### Dades Fiscals

![wizard_create_atr_m1_dades_fiscals]

En aquesta pestanya definirem les dades fiscals del titular i la forma de pagament

#### Tarifa Comercialitzadora

Utilitzant el check de `Canvia Tarifa Comercialitzadora` podrem decidir si canviarem la llista de preus.

En cas de canviar la llista de preus verificar que el mode de facturació és l'adequat.

#### Activació

Aquí podem definir quan volem sol·licitar el canvi de titular, hi ha varies opcions:

- `La activación se debe producir cuanto antes`
- `La activación se debe producir con próxima lectura del ciclo`
- `La activación se producirá según la fecha fija solicitada`

## Pas 02: Acceptacio del canvi

La distribuïdora ens informa que ha rebut la sol·licitud del canvi i que és correcte o que no és correcte.

En cas de no ser correcte s'haurà de tornar a fer l'M1, corregint els canvis erronis que ens digui la distribuïdora.

## Pas 05: Activacio del canvi

La distribuïdora ens envia l'activació que de forma automàtica l'erp ja carregarà i farà el canvi de titular amb tota la informació actualitzada des de distribuïdora.

[wizard_create_atr]: /gisce/clients/canvi_de_titular/wizard_create_atr.png
[wizard_create_atr_m1]: /gisce/clients/canvi_de_titular/wizard_create_atr_m1.png
[wizard_create_atr_m1_canvi_titular]: /gisce/clients/canvi_de_titular/wizard_create_atr_m1_canvi_titular.png
[wizard_create_atr_m1_contacte]: /gisce/clients/canvi_de_titular/wizard_create_atr_m1_contacte.png
[wizard_create_atr_m1_dades_fiscals]: /gisce/clients/canvi_de_titular/wizard_create_atr_m1_dades_fiscals.png
[wizard_create_atr_m1_titular]: /gisce/clients/canvi_de_titular/wizard_create_atr_m1_titular.png
[wizard_create_atr_m1_contracte_nou]: /gisce/clients/canvi_de_titular/wizard_create_atr_m1_contracte_nou.png
[^generacio_contracte_m1]: [Metode per generar contracte en esborrany](/gisce/code/interest_procedures.md#crear-polissa-en-esborrany-per-canvi-de-titular-m1).
[^nova_polissa_segons_variable]: Variable amb nom `sw_m1_owner_change_subrogacio_new_contract`.
[^nom_contacte]: Si posem el tipus Jurídic només hem d'informar el Nom de l'empresa.
