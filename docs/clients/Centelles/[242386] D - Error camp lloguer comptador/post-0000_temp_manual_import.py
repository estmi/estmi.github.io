# -*- coding: utf-8 -*-
import logging
from oopgrade.oopgrade import load_data_records

def up(cursor, installed_version):
    if not installed_version:
        return

    logger = logging.getLogger('openerp.migration')
   
    migration_filename = 'temp_migration'
    module_name = 'giscedata_facturacio'
    filename = 'giscedata_facturacio_data.xml'
    records_ids = ['uom_aql_elec_dia']

    logger.info('START:[{}]load_data_records'.format(migration_filename))
    load_data_records(cursor, module_name, filename, records_ids, mode='update')
    logger.info('END:[{}]load_data_records'.format(migration_filename))


def down(cursor, installed_version):
    pass


migrate = up
