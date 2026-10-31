const MAPS_SEARCH_URL = 'https://www.google.com/maps/search/';
const MAPS_DIRECTIONS_URL = 'https://www.google.com/maps/dir/';
const MAPS_EMBED_URL = 'https://www.google.com/maps/embed/v1/place';

function getPlaceQuery(place) {
  if (Number.isFinite(place.latitude) && Number.isFinite(place.longitude)) {
    return `${place.latitude},${place.longitude}`;
  }

  return [place.name, place.address].filter(Boolean).join(', ');
}

function buildGoogleMapsLinks(place) {
  const query = getPlaceQuery(place);
  if (!query) return null;

  const search = new URL(MAPS_SEARCH_URL);
  search.searchParams.set('api', '1');
  search.searchParams.set('query', query);

  const directions = new URL(MAPS_DIRECTIONS_URL);
  directions.searchParams.set('api', '1');
  directions.searchParams.set('destination', query);
  if (place.placeId) {
    directions.searchParams.set('destination_place_id', place.placeId);
  }

  let embedUrl = null;
  const apiKey = process.env.GOOGLE_MAPS_EMBED_API_KEY?.trim();
  if (apiKey) {
    const embed = new URL(MAPS_EMBED_URL);
    embed.searchParams.set('key', apiKey);
    embed.searchParams.set(
      'q',
      place.placeId ? `place_id:${place.placeId}` : query,
    );
    embed.searchParams.set('zoom', '16');
    embedUrl = embed.toString();
  }

  return {
    provider: 'google_maps',
    searchUrl: search.toString(),
    directionsUrl: directions.toString(),
    embedUrl,
  };
}

module.exports = { buildGoogleMapsLinks };
