class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  @@stocklist = ["ABP", "ABC", "APT", "AGL", "ALQ", "ALU", "AWC", "AMC", "AMP", "ANN", "APE", "APA", "APX", "ARB", "ALL", "ASX", "ALX", "AZJ", "AST", "ASB", "ANZ", "AVH", "BOQ", "BAP", "BPT", "BGA", "BEN", "BHP", "BIN", "BKL", "BSL", "BLD", "BXB", "BVS", "BRG", "BKW", "BWP", "CTX", "CAR", "CGF", "CHC", "CLW", "CQR", "CNU", "CIM", "CWY", "CUV", "CCL", "COH", "COL", "CKF", "CBA", "CPU", "COE", "CTD", "CGC", "CCP", "CMW", "CWN", "CSL", "CSR", "DXS", "DHG", "DMP", "DOW", "ELD", "EML", "EHE", "EVN", "FPH", "FBU", "FLT", "FMG", "GUD", "GEM", "GOR", "GMG", "GPT", "GNC", "GOZ", "GWA", "HVN", "HLS", "HUB", "IEL", "IGO", "ILU", "IPL", "INA", "ING", "IAG", "IVC", "IFL", "IPH", "IRE", "JHX", "JHG", "JBH", "JIN", "LLC", "A2M", "LNK", "LYC", "MFG", "MGR", "MIN", "MMS", "MND", "MPL", "MQG", "MTS", "MYX", "NAB", "NAN", "NCM", "NEA", "NEC", "NHC", "NHF", "NSR", "NST", "NUF", "NWH", "NWL", "NWS", "NXT", "OML", "ORA", "ORE", "ORG", "ORI", "OSH", "OZL", "PDL", "PLS", "PME", "PMV", "PNI", "PNV", "PPT", "PRN", "PTM", "QAN", "QBE", "QUB", "REA", "RHC", "RIO", "RMD", "RRL", "RSG", "RWC", "S32", "SAR", "SBM", "SCG", "SCP", "SDF", "SEK", "SFR", "SGM", "SGP", "SGR", "SHL", "SIQ", "SKC", "SKI", "SLR", "SOL", "SPK", "SSM", "STO", "SUL", "SUN", "SVW", "SXL", "SYD", "TAH", "TCL", "TGR", "TLS", "TNE", "TPM", "TWE", "UMG", "URW", "VCX", "VEA", "VOC", "VUK", "VVR", "WBC", "WEB", "WES", "WHC", "WOR", "WOW", "WPL", "WSA", "WTC", "XRO"]

  def self.testuserisnew(user_id)
    if User.where(:id => user_id).pluck(:startingstock1).first == nil
      p "!!!!!!! Users has NO start stocks"
      return true
    else
      p "!!!!!!! Users has all the start stocks"
      return false
    end
  end

  def self.new_user(user_id)
    for i in 1..4
      stock_id = @@stocklist.shuffle.first
      User.where(:id => user_id).update_all((("startingstock#{i}").to_sym) => (stock_id))
      Holding.getlivestockprice(stock_id)
    end 
  end

  def self.testusersigninsteps2(user_id)
    if User.where(:id => user_id).pluck(:signinstep).first == 1
      p "!!!!! User has not compleated setup"
      return true
    else
      return false
    end
  end
  
  def self.validusers
    list = []
    User.each do |user|
      if user[:signinstep] == 2
        list << user[:id]
      end
    end
    return list
  end
end
 