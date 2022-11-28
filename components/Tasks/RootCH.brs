sub GetContent()
    items = []
    rows=[]
    url=CreateObject("roUrlTransfer")
    url.SetCertificatesFile("common:/certs/ca-bundle.crt")
    url.SetUrl("https://no-cache.s3.us-east-2.amazonaws.com/vyarchych-home/tec/public_vids.json")
    response=ParseJSON(url.GetToString())

    for each video in response?["categories"]?[0]?["videos"]
        node = CreateObject("roSGNode","ContentNode")
        node.Title = video.title
        node.description = video.description
        node.HDPosterUrl = video.thumb
        node.url = video.sources[0]
        rows.Push(video.interactiveAd)
        items.Push(node)
    end for
    
    nodeCreated={}
    nodeCreated.title="Contents"
    nodeCreated.children=items

    listNode=[nodeCreated]

    m.global.addFields({ads:adsArr})
    m.top.content.Update({children: listNode})
end sub
