sub GetContent()
    items = []
    
    url = CreateObject("roUrlTransfer")
    url.SetCertificatesFile("common:/certs/ca-bundle.crt")
    url.SetUrl("https://no-cache.s3.us-east-2.amazonaws.com/vyarchych-home/tec/public_vids.json")
    
    response = ParseJson(url.GetToString())
    
    for each video in response?["categories"]?[0]?["videos"]
        node = CreateObject("rosgnode","ContentNode")
        node.addFields({ad:video.interactiveAd})
        node.Title= video.title
        node.description= video.description
        node.HDPosterURL= video.thumb
        
        
        node.url= video.sources[0]
                
        
        
        
        
        items.Push(node)
    end for
    node2 = {}
    node2.title="First Row Content"
    node2.children=items

    rows =[ node2]
        
    m.top.content.Update({children:rows})    
end sub