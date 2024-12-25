# Quixotic Lucera

- [Install Insomnia](#install-insomnia)
- [Import Quixotic's config](#import-quixotics-config)

## Install Insomnia

Utilitzar aplicatiu `Insomnia`, per instalar, anar a la seva web i instalar.\
Web: [https://insomnia.rest/download](https://insomnia.rest/download)\
.deb: [Insomnia_deb]

```console
(erp) ┌─[estevemiquel@pc-estevemiquel] - [~] - [jue jul 18, 10:41]
└─[$] <> sudo dpkg -i Downloads/Insomnia.Core-9.3.2.deb 
Selecting previously unselected package insomnia.
(Reading database ... 239009 files and directories currently installed.)
Preparing to unpack .../Insomnia.Core-9.3.2.deb ...
Unpacking insomnia (9.3.2) ...
Setting up insomnia (9.3.2) ...
update-alternatives is /usr/bin/update-alternatives
update-alternatives: using /opt/Insomnia/insomnia to provide /usr/bin/insomnia (insomnia) in auto mode
Could not parse file "/usr/share/applications/guake.desktop": No such file or directory
Processing triggers for hicolor-icon-theme (0.17-2) ...
Processing triggers for mailcap (3.70+nmu1ubuntu1) ...
Processing triggers for gnome-menus (3.36.0-1ubuntu3) ...
Processing triggers for desktop-file-utils (0.26-1ubuntu3) ...
```

## Import Quixotic's config

Un cop instalat l'obrirem i farem clic a Create -> Import:\
![Insomnia_import]\
![Insomnia_import_file]

Aqui li donarem el fitxer de configuracio de l'api de quixotic: [Insomnia_quixotic_config], Farem clic a `Scan` i despres a `Import`.\
![Insomnia_import_file_import]

Un cop sigui importat veurem el seguent:\
![Insomnia_lucera_quixotic_collection_imported]

[Insomnia_deb]: /gisce_data/lucera/quixotic/insomnia_core_9_3_2.deb
[Insomnia_quixotic_config]: quixotic_config.md
[Insomnia_import]: /gisce_data/lucera/quixotic/insomnia_import.png
[Insomnia_import_file]:/gisce_data/lucera/quixotic/Insomnia_import_file.png
[Insomnia_import_file_import]: /gisce_data/lucera/quixotic/Insomnia_import_file_import.png
[Insomnia_lucera_quixotic_collection_imported]: /gisce_data/lucera/quixotic/Insomnia_lucera_quixotic_collection_imported.png
