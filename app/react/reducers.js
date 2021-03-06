/* @flow */
import { reducer as onionForm } from 'onion-form';
import { routerReducer as routing } from 'react-router-redux';

import device from './device/reducer';
import ui from './ui/reducer';
import projects from './projects/reducer';
import keys from './keys/reducer';
import locales from './locales/reducer';
import forms from './forms/reducers';
import hierarchy from './hierarchy/reducer';
import releases from './releases/reducer';

import type { StateType } from './types/storeTypes';

const store: StateType = {
  device,
  onionForm,
  routing,
  ui,
  projects,
  keys,
  locales,
  forms,
  hierarchy,
  releases
};

export default store;
