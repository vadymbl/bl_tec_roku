# List of assignments (follow the order)
1. Fork this repository. Work inside your repository and create PR from it to this repo (into master branch)
2. Change the sources to use SGDEX GridView instead of VideoSelectionScreen (please use Content Handler to create and populate content node);
3. Change the sources to use SGDEX MediaView instead of RSG Video node;
4. Get content for the channel using http request. Inside ContentHandler, http requests can be done using roUrlTransfer object. Use the following link to get json with videos 'https://no-cache.s3.us-east-2.amazonaws.com/vyarchych-home/tec/public_vids.json'. Parse it to the appropriate content structure (which can be displayed on GridView).
5. Implement showing of interactive ads using BrightLine SDK. Each video has interactiveAd object with all needed data for rendering interactive ad. Documentation how to integrate BrightLine SDK - https://cdn-media.brightline.tv/sdk/gen2/guides/roku_direct_new.html; load SDK from this url - https://cdn-media.brightline.tv/sdk/gen2/roku/direct/pkgs/BrightLineDirect-3.0.2.pkg

## Notes
Please create the merge request for each assignment. To have step by step progress.
