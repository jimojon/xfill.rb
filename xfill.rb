require 'nokogiri'
require 'FileUtils'

def parse(from, to)
    replacementCount = 0
    files = Dir.glob(from+'*').select{ |e| File.file? e }
    files.each do |file|
        replacementCount += parseXML(File.basename(file), from, to)
    end
    print (replacementCount).to_s + ' filling'+(replacementCount > 1 ? 's' : '')+"\n"
end

def parseXML(filename, from, to)
    
    attributes = ['label', 'title', 'subtitle', 'categ']
    
    replacement = 'xx'
    replacementCount = 0
    
    f = File.open(from+filename)
    doc = Nokogiri::XML(f)
    f.close
    
    leaves = doc.xpath('//*')
    leaves.each do |node|
        
        #print node.name+" "+(node.elements.length).to_s+"\n"
        
        if node.elements.length == 0
            #print node.name, " -> ", node.inner_text+"\n"
            if node.content != ''
                node.content = replacement
                replacementCount += 1
            end
        end
        
        attributes.each do |a|
            if node.attr(a)
                node.set_attribute(a, replacement)
                replacementCount += 1
            end
        end
    
    end
    
    #print doc.to_html
    FileUtils::mkdir_p to
    File.open(to+filename, 'w') {|f| f.write(doc.to_xml) }
    
    return replacementCount
end

parse('data/en/', 'data/xx/')
#parseXML("test.xml", "data/en/", "data/xx/")



