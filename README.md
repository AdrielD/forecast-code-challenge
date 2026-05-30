# README

Hi!

First decision I took for this code challenge, to make it easier on me and
my time, was to generate the Rails app with the --api flag, since this is the
way I work with most production applications (I rarelly see prod applications
using pure .erb nowadays, but maybe I'm biased).

I'll focus on functionality first, and then add some mockup HTML page with
express and tailwind, if there's enought time. The core solution will be
delivered as a REST API response.

-----

Second decision, I'm going to use Google's APIs for geocoding and weather.
You type and address, the geocoding API returns the zip code we need for
cacheing, and the lat / lng coords used in the weather API.

As a pattern, I usually use a "Service" class to deal with business logic
outside controllers and models. I've seen this pattern being called other 
things as well, such as "operations" or "iteractors", but the idea is the
same: a single entry point (a .call or .execute method), some validation
and then the actual processing.
