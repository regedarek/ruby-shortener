class Link
  # Retrieve the link with the given code
  # Raises Sinatra::NotFound if no such record
  #
  def self.find_by_code!(code)
    get(code.to_i(36)) or raise Sinatra::NotFound
  end
 
  # Return the code for this link. The code is the id in base 36 (all digits
  # plus all lowercase letters).
  #
  def code
    id ? id.to_s(36) : nil
  end  
end
