sub GetContent()
    items = []
    json = ParseJSON(ReadAsciiFile("pkg:/feed/home.json"))
    for each video in json.videos
        items.Push({
            title: video.title
            url: video.url
        })
    end for
    m.top.content.Update({children: items})
end sub
