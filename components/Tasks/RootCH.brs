sub GetContent()
    items = []
    rows = []
    url = CreateObject("roUrlTransfer")
    url.SetCertificatesFile("common:/certs/ca-bundle.crt")
    url.SetUrl("https://no-cache.s3.us-east-2.amazonaws.com/vyarchych-home/tec/public_vids.json")
    body = url.GetToString()
    ?body
    json = ParseJSON(body)
    ?json
    for each video in json?["categories"]?[0]?["videos"]
        ?video
        ?video.sources[0]
        node = CreateObject("roSGNode","ContentNode")
        node.Title = video.title
        node.description = video.description
        node.HDPosterUrl = video.thumb
        node.url = video.sources[0]
        items.Push(node)

    end for

    rows.Push({
        children: items,
        title: "Sample videos"
    })


    m.top.content.Update({children: rows})
end sub
