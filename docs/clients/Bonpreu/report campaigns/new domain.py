[
('active', '=', True),
('data_renovacio', '>=', '2025-03-10'),
('data_renovacio', '<=', '2025-03-16'),
('enviament', '=', 'postal'),
('state','=','activa'),
('mode_facturacio', '!=', 'index'), 
 '|', 
    '&', 
        ('llista_preu', '!=', Field('next_pricelist_id')), 
        ('next_pricelist_id', '!=', False), 
    ('llista_preu', '!=', Field('llista_preu.next_pricelist_id'))
]
