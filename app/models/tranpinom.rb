class Tranpinom < Tran

  validates_presence_of :trdetails
  validates_presence_of :tramount
  validates_presence_of :netamount
  validates_presence_of :nominal

  # Amount must be a number greater than 00.01
  validates_numericality_of :netamount, :greater_than_or_equal_to => 0.01
  validates_numericality_of :tramount, :greater_than_or_equal_to => 0.01

  after_create do 
    tranhead.update_column(:trtrantype, 'NOM')
    tranhead.update_column(:troffcli, 'P')
    tranhead.update_column(:trpayrec, 'I')
  end 

  after_save do 

    if !self.vat.nil?
      self.update_column(:vatperc, self.vat.vatperc)
    end

    self.nomtran.delete_all

    if !self.netamount.nil?
      if self.netamount != 0
        # This is to add a record to the Nomtrans Table for the Fees
        Nomtran.create({ amount: netamount, date: tranhead.trdate, 
                         nominal_id: nominal_id, ttype: 'I', tran: self, nomcode: nominal.code })
      end
    end 
    
    if !self.vat.nil?
      if self.vatamount != 0
        # This is to add a record to the Nomtrans Table for the VAT
        Nomtran.create({ amount: vatamount, date: tranhead.trdate, 
                         vat_id: vat_id, ttype: 'I', tran: self, nomcode: 'VAT' })
      end
    end 

  end

end 
