class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :number
      t.string :reg_address_care_of, nil: true
      t.string :reg_address_po_box, nil: true
      t.text :reg_address_po_box_1, nil: true
      t.text :reg_address_po_box_2, nil: true
      t.string :reg_address_post_town, nil: true
      t.string :reg_address_county, nil: true
      t.string :reg_address_country, nil: true
      t.string :reg_address_post_code, nil: true
      t.string :company_category, nil: true
      t.string :company_status, nil: true
      t.string :country_of_origin, nil: true
      t.date :dissolution_date, nil: true
      t.date :incorporation_date, nil: true
      t.integer :accounts_account_ref_day, nil: true
      t.integer :accounts_account_ref_month, nil: true
      t.date :accounts_next_due_date, nil: true
      t.date :accounts_last_made_up_date, nil: true
      t.string :accounts_account_category, nil: true
      t.date :returns_next_due_date, nil: true
      t.date :returns_last_made_up_date, nil: true
      t.integer :mortgages_num_mort_charges, nil: true
      t.integer :mortgages_num_mort_outstanding, nil: true
      t.integer :mortgages_num_mort_part_satisfied, nil: true
      t.integer :mortgages_num_mort_satisfied, nil: true
      t.text :sic_code_sic_text_1, nil: true
      t.text :sic_code_sic_text_2, nil: true
      t.text :sic_code_sic_text_3, nil: true
      t.text :sic_code_sic_text_4, nil: true
      t.integer :limited_partnerships_num_gen_partners, nil: true
      t.integer :limited_partnerships_num_lim_partners, nil: true
      t.text :uri, nil: true
      t.date :previous_name_1_condate, nil: true
      t.string :previous_name_1_company_name, nil: true
      t.date :previous_name_2_condate, nil: true
      t.string :previous_name_2_company_name, nil: true
      t.date :previous_name_3_condate, nil: true
      t.string :previous_name_3_company_name, nil: true
      t.date :previous_name_4_condate, nil: true
      t.string :previous_name_4_company_name, nil: true
      t.date :previous_name_5_condate, nil: true
      t.string :previous_name_5_company_name, nil: true
      t.date :previous_name_6_condate, nil: true
      t.string :previous_name_6_company_name, nil: true
      t.date :previous_name_7_condate, nil: true
      t.string :previous_name_7_company_name, nil: true
      t.date :previous_name_8_condate, nil: true
      t.string :previous_name_8_company_name, nil: true
      t.date :previous_name_9_condate, nil: true
      t.string :previous_name_9_company_name, nil: true
      t.date :previous_name_10_condate, nil: true
      t.string :previous_name_10_company_name, nil: true
      t.date :conf_stmt_next_due_date, nil: true
      t.date :conf_stmt_last_made_up_date, nil: true
    end

    add_index :companies, :number, unique: true
  end
end
