/* @flow */
import type { Interface } from 'interfacer';
import type { StateType } from './storeTypes';

export type ID = string;

export type Action = Object;

export type Dependencies = {
  dispatch: (action: Action) => any,
  dispatchAndThrow: (action: Action, error: Error) => any,
  dispatchPromise: (action: Action) => any,
  getState: () => StateType,
  hierarchyInterface: Interface,
  keysInterface: Interface,
  localesInterface: Interface,
  projectsInterface: Interface,
  translationsInterface: Interface,
  releasesInterface: Interface,
  genericInterface: Interface
};

export type PaginationType = {
  currentPage: number,
  nextPage: number | null,
  prevPage: number | null,
  totalPages: number,
  totalCount: number
}

export type InputEvent =
  Event & {
    currentTarget: HTMLInputElement,
    keyCode: number
  };

export type KeyNode = {
  level: number,
  label: string,
  childrenKeys: Array<KeyNode>
}
