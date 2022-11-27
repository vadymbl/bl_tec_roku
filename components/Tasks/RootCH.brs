sub GetContent()
    url = CreateObject("roUrlTransfer")
    url.SetUrl("http://no-cache.s3.us-east-2.amazonaws.com/vyarchych-home/tec/public_vids.json")
    response = url.GetToString()
    json = ParseJSON(response)

    VIDS_PER_ROW = 5
    col_count = 0

    adsFromJson = []
    rows = []
    actualRow = []
    vids = json.categories[0].videos

    for each video in vids
        movie = CreateObject("roSGNode", "ContentNode")
        movie.description = video.description
        movie.url = video.sources[0]
        movie.subtitle = video.subtitle
        movie.hdPosterUrl = video.thumb
        movie.title = video.title
        adsFromJson.Push(video.interactiveAd)

        IF col_count < VIDS_PER_ROW THEN
            actualRow.Push(movie)
            col_count = col_count + 1
        ELSE
            rows.Push({
                title: "Section " + (rows.Count() + 1).tostr(),
                children: actualRow
            })
            actualRow = []
            actualRow.Push(movie)
            col_count = 1
        END IF
        
        ' Adding last row, may be not full
        IF (((rows.Count()) * VIDS_PER_ROW) + col_count) = vids.Count() THEN
            rows.Push({
                title: "Section " + (rows.Count() + 1).tostr(),
                children: actualRow
            })
            exit for
        END IF
    end for

    m.global.addFields({
        ads: adsFromJson,
        row_delimiter: VIDS_PER_ROW
    })
    m.top.content.Update({children: rows})
end sub
