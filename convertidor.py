import json
import xml.etree.ElementTree as ET

def xml_node_to_dict(element):

    node_dict = {}
    
    if element.attrib:
        node_dict["@attributes"] = element.attrib

    children = list(element)
    if children:
        child_dict = {}
        for child in children:
            child_data = xml_node_to_dict(child)
       
            if child.tag in child_dict:
                if not isinstance(child_dict[child.tag], list):
                    child_dict[child.tag] = [child_dict[child.tag]]
                child_dict[child.tag].append(child_data)
            else:
                child_dict[child.tag] = child_data
        
        node_dict.update(child_dict)

    text = element.text.strip() if element.text else ""
    if text:
        if not node_dict:
            return text  
        else:
            node_dict["#text"] = text

    return node_dict


def convert_large_xml_to_json(xml_file_path, json_file_path, record_tag):

    
    count = 0
    with open(json_file_path, "w", encoding="utf-8") as json_file:
        json_file.write("[\n") 
        
        first = True
      
        context = ET.iterparse(xml_file_path, events=("end",))
        
        for event, elem in context:
            if elem.tag == record_tag:
               
                record_data = {elem.tag: xml_node_to_dict(elem)}

                if not first:
                    json_file.write(",\n")
                else:
                    first = False
                
                json.dump(record_data, json_file, ensure_ascii=False, indent=2)

                elem.clear()
                count += 1
                
                if count % 10000 == 0:
                    print(f"Procesados {count} registros...")

        json_file.write("\n]")  
        
    print(f"¡Proceso completado! Se convirtieron {count} registros en '{json_file_path}'.")


if __name__ == "__main__":
  
    ARCHIVO_XML = "entrada_extensa.xml"
    ARCHIVO_JSON = "salida.json"
    
    ETIQUETA_REGISTRO = "item" 
    
    convert_large_xml_to_json(ARCHIVO_XML, ARCHIVO_JSON, ETIQUETA_REGISTRO)