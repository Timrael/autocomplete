class RemoveUselessFieldsFromCompanies < ActiveRecord::Migration[5.2]
  def change
    remove_column :companies, :reg_address_care_of
    remove_column :companies, :reg_address_po_box
    remove_column :companies, :reg_address_po_box_1
    remove_column :companies, :reg_address_po_box_2
    remove_column :companies, :reg_address_post_town
    remove_column :companies, :reg_address_county
    remove_column :companies, :reg_address_country
    remove_column :companies, :reg_address_post_code
    remove_column :companies, :company_category
    remove_column :companies, :company_status
    remove_column :companies, :country_of_origin
    remove_column :companies, :dissolution_date
    remove_column :companies, :incorporation_date
    remove_column :companies, :accounts_account_ref_day
    remove_column :companies, :accounts_account_ref_month
    remove_column :companies, :accounts_next_due_date
    remove_column :companies, :accounts_last_made_up_date
    remove_column :companies, :accounts_account_category
    remove_column :companies, :returns_next_due_date
    remove_column :companies, :returns_last_made_up_date
    remove_column :companies, :mortgages_num_mort_charges
    remove_column :companies, :mortgages_num_mort_outstanding
    remove_column :companies, :mortgages_num_mort_part_satisfied
    remove_column :companies, :mortgages_num_mort_satisfied
    remove_column :companies, :sic_code_sic_text_1
    remove_column :companies, :sic_code_sic_text_2
    remove_column :companies, :sic_code_sic_text_3
    remove_column :companies, :sic_code_sic_text_4
    remove_column :companies, :limited_partnerships_num_gen_partners
    remove_column :companies, :limited_partnerships_num_lim_partners
    remove_column :companies, :uri
    remove_column :companies, :previous_name_1_condate
    remove_column :companies, :previous_name_2_condate
    remove_column :companies, :previous_name_3_condate
    remove_column :companies, :previous_name_4_condate
    remove_column :companies, :previous_name_5_condate
    remove_column :companies, :previous_name_6_condate
    remove_column :companies, :previous_name_7_condate
    remove_column :companies, :previous_name_8_condate
    remove_column :companies, :previous_name_9_condate
    remove_column :companies, :previous_name_10_condate
    remove_column :companies, :conf_stmt_next_due_date
    remove_column :companies, :conf_stmt_last_made_up_date
  end
end
