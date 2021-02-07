require 'creek'
require 'write_xlsx'


class ExcelTool

  #xlsx xlsm not xls
  #{
  # Sheet1: [{'A1' => xx, 'B1' => xx}, {'A1' => xx, 'B1' => xx},...],
  # Sheet2: [{'A1' => xx, 'B1' => xx}, {'A1' => xx, 'B1' => xx},...],
  #}
  def parseExcel(path)
    creek = Creek::Book.new(path) 
    return parse(creek)
  end

  def parseExcelFromUrl(url)
    creek = Creek::Book.new url, remote: true
    return parse(creek)
  end

  #  obj = 
  #    {
  #     sheet1: [['a1', 'a2', 'a3'], ['b1','b2','b3']],
  #     sheet2: [['a1', 'a2', 'a3'], ['b1','b2','b3']]
  #    }
  #  tool = ExcelTool.new
  #  tool.exportToExcel(obj, "ruby")
  def exportToExcel(obj, filename)
    template_dir = File.join(Rails.root, "public", "excel")
    Dir::mkdir(template_dir) unless File.directory?(template_dir)
    target_excel = File.join(Rails.root, "public", "excel", filename + '.xlsx') 

    workbook = WriteXLSX.new(target_excel)

    #format = workbook.add_format
    #format.set_bold
    #format.set_color('red')
    #format.set_align('center')
    #worksheet.write(row, col, "Hi Excel!", format)

    obj.each do |key, value|
      worksheet = workbook.add_worksheet(key)
      value.each_with_index do |item, row|
        item.each_with_index do |val, col|
          worksheet.write(row, col, val)
        end
      end
    end

    workbook.close

    return target_excel
  end

  private 
    def parse(creek)
      hash = Hash.new
      creek.sheets.each do |sheet| 
        row_arr = []
        sheet.with_images.rows.each do |row|
          row_arr << row
        end
        hash[sheet.name] =row_arr
      end
      hash
    end
end
