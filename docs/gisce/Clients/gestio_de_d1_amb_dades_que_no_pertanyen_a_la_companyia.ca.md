# Gestió de D1 amb dades que no pertanyen a cap client de la companyia

## Llei de protecció de dades

La llei de protecció de dades ens marca que no es poden guardar dades confidencials d'una persona sense el seu consentiment en el erp.

## Error

En alguns D1-01, generalment els col·lectius en els quals el propietari del generador és extern a la companyia, no ha tingut mai un contracte amb la companyia, ens podem trobar un error com aquest:

![imatge_activacio_d1_error]

Aquest error ens indica que no tenim les dades del generador a l'erp:

- Degut de la llei de protecció de dades l'erp no importa les dades del generador automàticament si el NIF/NIE del propietari del generador no es troba ja dins de l'erp.

## Com procedirem

Ens haurem de posar en contacte amb el propietari del generador per poder obtenir les seves dades i una acceptació explicita que ens permeti emmagatzemar les seves dades a l'erp. Un cop ho tinguem, crearem una nova empresa amb el NIF que ens ha donat el propietari de la instal·lació de generació i activarem el D1.

## Configuracions

Sota la responsabilitat de la pròpia empresa, es pot desactivar una variable de configuració que importarà de forma automàtica les dades del propietari del generador des del D1, però no es tindrà cap mena de consentiment per fer això i s'hauria d'obtenir el consentiment firmant algun document de protecció de dades amb el propietari del generador.

En cas de voler desactivar la configuració ens podeu enviar un SAC sol·licitant explícitament que es volen importar automàticament aquestes dades, sempre sota la responsabilitat del sol·licitant.

[imatge_activacio_d1_error]: /gisce/clients/gestio_de_d1_amb_dades_que_no_pertanyen_a_la_companyia/error_activacio_d1.png
