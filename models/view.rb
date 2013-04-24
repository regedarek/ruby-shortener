class View

  # Return browser statistics for given Link
  #
  #  Ex:
  #   [["Chrome", 2], ["Firefox", 3]]
  #
  def self.stats(link_id)
    aggregate(:browser.count, fields: [:browser], conditions: ['link_id = ?', link_id])
  end

end
