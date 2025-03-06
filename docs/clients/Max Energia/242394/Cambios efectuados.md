# Actualitzar delegado territorial

## PRE

| id  | delegacio_territorial | delegat |
|-----|-----------------------|---------|
| 978 | f                     |     537 |
| 882 | f                     |     537 |
| 894 | f                     |     537 |
| 550 |                       |     537 |
| 527 |                       |     537 |
| 537 | t                     |     537 |
| 905 | f                     |     537 |
| 538 |                       |     537 |
| 850 | f                     |     537 |
| 840 | f                     |     537 |
| 849 | f                     |     537 |
| 817 |                       |     537 |
| 848 | f                     |     537 |
| 851 | f                     |     537 |
| 852 | f                     |     537 |
| 853 | f                     |     537 |
| 854 | f                     |     537 |
| 855 | f                     |     537 |
| 856 | f                     |     537 |
| 857 | f                     |     537 |
| 858 | f                     |     537 |
| 859 | f                     |     537 |
| 860 | f                     |     537 |
| 861 | f                     |     537 |
| 862 | f                     |     537 |
| 863 | f                     |     537 |
| 541 |                       |     537 |
| 808 |                       |     537 |
| 824 | f                     |     537 |
| 826 | f                     |     537 |
| 526 |                       |     537 |
| 502 |                       |     537 |

## SQL

```sql
update hr_colaborador set delegat = 1262 where id in (978, 882, 894, 550, 527, 537, 905, 538, 850, 840, 849, 817, 848, 851, 852, 853, 854, 855, 856, 857, 858, 859, 860, 861, 862, 863, 541, 808, 824, 826, 526, 502);
```

## POST

|  id  | delegacio_territorial | delegat |             name              |
|------|-----------------------|---------|-------------------------------|
|  978 | f                     |    1262 | HORFERASTUR SL |
| 1262 | t                     |    1262 | Diego Otero|
|  853 | f                     |    1262 | NOELIA FRAGA ROCA|
|  854 | f                     |    1262 | DANIEL LEA GONZALEZ|
|  855 | f                     |    1262 | ALBERTO BURON ROCHA|
|  856 | f                     |    1262 | REBECA FERNANDEZ LACASA|
|  857 | f                     |    1262 | EDUARDO PIÑERO REDONDO|
|  858 | f                     |    1262 | RAMON SARILLE GARCIA|
|  859 | f                     |    1262 | Mª DEL CARMEN CALO LIÑEIRO|
|  860 | f                     |    1262 | EDUARDO CARO FERNANDEZ|
|  861 | f                     |    1262 | ELECTRYGAS ENERGIA SL|
|  862 | f                     |    1262 | CARLOS GONZALEZ GARCIA|
|  863 | f                     |    1262 | JOSE BENITO FAILDE SANCHEZ|
|  882 | f                     |    1262 | Miguel Corrales Palma|
|  550 |                       |    1262 | NEW PULSO ENERGY|
|  894 | f                     |    1262 | MCARMEN SANCHEZ BERMEJO|
|  527 |                       |    1262 | Jose Manuel Priegue Pais|
|  537 | t                     |    1262 | Fernando Saavedra|
|  538 |                       |    1262 | VERTIGO SOLUTIONS SL|
|  905 | f                     |    1262 | SEL LUZ Y GAS |
|  840 | f                     |    1262 | AMARBI INNOVACION|
|  849 | f                     |    1262 | ANA LUCIA MOUZO BLANCO|
|  850 | f                     |    1262 | JUAN MANUEL FERNANDEZ SINGH|
|  541 |                       |    1262 | BLOUR GRUPO |
|  808 |                       |    1262 | ASOC. ENERG. INTEGRAL LEDS GO|
|  817 |                       |    1262 | ACOM|
|  824 | f                     |    1262 | Planificacion Estrategica|
|  826 | f                     |    1262 | SERVIPRONOR 2023 S.L|
|  848 | f                     |    1262 | CARLOS CASTRO REY|
|  851 | f                     |    1262 | MANUEL PERISCAL BARCA|
|  852 | f                     |    1262 | JACOBO DAVIÑA GAYOSO|
|  526 |                       |    1262 | ENERGITEL GALICIA, S.L.|
|  502 |                       |    1262 | INERGA SL|
