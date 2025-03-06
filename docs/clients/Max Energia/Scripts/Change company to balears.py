def mandangues_company_balears(c, pnames_str, update_comissions=True):
    from tqdm import tqdm

    def fix_mandangues_balears(c, pname, update_comissions):
        pol_o = c.GiscedataPolissa
        mod_o = c.GiscedataPolissaModcontractual
        pid = pol_o.search([('name','=',pname)])
        if not pid:
            return False
        pid = pid
        pmode_actual = pol_o.read(pid[0], ['payment_mode_id'])['payment_mode_id'][0]
        modcon_actual = pol_o.read(pid[0], ['modcontractual_activa'])['modcontractual_activa'][0]
        newest_modcon = mod_o.search([('id','!=',modcon_actual), ('polissa_id', '=', pid[0]), ('payment_mode_id', '!=', pmode_actual)], 0, None, None, {'active_test': False})
        if not newest_modcon:
            newest_modcon = mod_o.search([('id', '!=', modcon_actual), ('polissa_id', '=', pid[0])], 0, None, None, {'active_test': False})
        if newest_modcon:
            newest_modcon = max(newest_modcon)
            old_pmode = mod_o.read(newest_modcon, ['payment_mode_id'])['payment_mode_id'][0]
        else:
            old_pmode = 50
        old_pmode = mod_o.read(newest_modcon, ['payment_mode_id'])['payment_mode_id'][0]
        values = {
            'company_id': 2,
            'payment_mode_id': old_pmode
        }
        mod_values = {
            'payment_mode_id': old_pmode
        }
        pol_o.write(pid, values)
        mod_o.write(modcon_actual, mod_values)
        pol_o.fix_serveis(pid[0])
        if update_comissions:
            com_o = c.GiscedataPolissaComissioMaxenergia
            com_id = com_o.search([('polissa_id', '=', pid[0])])[0]
            com = com_o.browse(com_id)
            if com.porcentage_fee_20td_under_10 != 90 or com.porcentage_fee_20td_over_10 != 90 or com.porcentage_fee_30td != 90 or com.porcentage_fee_6xtd != 90:
                vals = {
                'porcentage_fee_20td_under_10': 90,
                'porcentage_fee_20td_over_10':90,
                'porcentage_fee_30td':90,
                'porcentage_fee_6xtd':90}
                com.write(vals)
                if com.pagament_ids and len(com.pagament_ids) == 1:
                    com.pagament_ids[0].unlink()
                elif com.pagament_ids and len(com.pagament_ids) != 1:
                    import pudb;pu.db
            else:
                import pudb;pu.db
        return True

    pnames = pnames_str.strip().split("\n")
    err = []
    import pudb;pu.db
    for pname in tqdm(pnames):
        try:
            res = fix_mandangues_balears(c, pname, update_comissions)
        except Exception as e:
            res = False
        if not res:
            err.append(pname)
    return err