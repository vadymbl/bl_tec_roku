# List of assignments (follow the order)
1. Create student base branch, it should have name based on template {firstName}_{lastName};
2. Change the sources to use SGDEX GridView instead of VideoSelectionScreen (please use Content Handler to create and populate content node);
3. Change the sources to use SGDEX MediaView instead of RSG Video node;
4. Get content for the channel using http request. Inside ContentHandler, http requests can be done using roUrlTransfer object. Use the following link to get json with videos 'https://no-cache.s3.us-east-2.amazonaws.com/vyarchych-home/tec/public_vids.json'. Parse it to the appropriate content stracture (which can be displayed on GridView).
5. TBD

## Notes
Please create the merge request for each assignment except first. Merge requests should be opened against "student's master branch" which was created as first assignment.
