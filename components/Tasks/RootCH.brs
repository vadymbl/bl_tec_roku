sub GetContent()
    row = []
    json = ParseJSON(ReadAsciiFile("pkg:/feed/home.json"))
    for each video in json.videos
        movie = CreateObject("roSGNode", "ContentNode")
        movie.title = video.title
        movie.url = video.url
        movie.hdPosterUrl = video.hdPosterUrl
	    movie.description = "No description provided."
        row.Push(movie) 
    end for
    movieList = {
        title: "Movies",
        children: row
    }
    m.top.content.Update({children: [movieList]})
end sub
