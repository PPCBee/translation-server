export const FETCH_LOCALE_PENDING = 'FETCH_LOCALE_PENDING';
export const FETCH_LOCALE_FULFILLED = 'FETCH_LOCALE_FULFILLED';

export const fetchLocale = ({ params: { localeId }, query: { page } }) =>
  ({ localesInterface }) => ({
    type: 'FETCH_LOCALE',
    payload: {
      promise: localesInterface.get(localeId, {
        error: 'Locale information failed to fetch',
        query: { page },
      }),
    },
    meta: {
      localeId,
    },
  });
