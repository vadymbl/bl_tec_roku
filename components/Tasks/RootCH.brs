sub GetContent()
    rows = []
    oddItems = []
    evenItems = []
    flag = true

    url = CreateObject("roUrlTransfer")
    url.SetUrl("http://no-cache.s3.us-east-2.amazonaws.com/vyarchych-home/tec/public_vids.json")
    feed = url.GetToString()

    json = ParseJSON(feed)
    videos = json.categories[0].videos
    for p=0 to videos.count()-1
        video = videos[p]
        node = CreateObject("roSGNode", "ContentNode")
        node.setFields({
            description: video.description
            hdPosterUrl: video.thumb,
            title: video.title,
            url: video.sources[0]
        })
        if flag then
            oddItems.Push(node)
        else
            evenItems.Push(node)
        end if
        flag = NOT flag
    end for

    rows.Push({
        children: oddItems,
        title: "BL+TEC Samples (odd entries)"
    })
    rows.Push({
        children: evenItems,
        title: "BL+TEC Samples (even entries)"
    })
    m.top.content.Update({children: rows})
end sub
