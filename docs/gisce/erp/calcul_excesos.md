---
last_update:
  author: Agusti Fita
---
# Calcul de excesos i maximetres

## Distribuidora

Els excessos que s'agafen del comptador surten prioritàriament dels tancaments del comptador. Si el comptador disposa dels tancaments amb excessos (comptadors T3 o superior Telemesurats), el ERP els agafarà. Perquè quadrin amb la corva y la potència del contracte, el comptador físic ha de tenir correctament configurada la potència.

En el cas dels comptadors T3 telegestionats, no disposem de tancaments amb excessos de potència. En aquest cas , s'utilitza la corba de càrrega **horària** per "inferir" els excessos de potència. Evidentment, és una aproximació i es pot donar el cas que encara que el maxímetre sigui més alt (es fa per quart horària) un cop es té la corba horària aquest pic es pot dissimular.

## Comercialitzadora

S'agafen els excesos que s'han enviat des de distribuidotra y que venen per F1.
