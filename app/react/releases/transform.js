/* @flow */
import type { KeyNode } from '../types/generalTypes';

const maxLevel = 10;
const transformHierarchy = (structure: Object = {}, level: number = 0, path: Array<string> = []): Array<KeyNode> => {
  if (level > maxLevel) {
    // eslint-disable-next-line no-console
    console.warn('Provided hierarchy object was to deep. Either provide different object or increase "maxLevel" variable');
    return [];
  }
  return Object.keys(structure)
    .map((key: string): KeyNode => {
      const childrenKeys = transformHierarchy(structure[key], level + 1, [...path, key]);
      return {
        level,
        label: key,
        isEndNode: !childrenKeys.length,
        path: [...path, key],
        childrenKeys
      };
    });
};

export default transformHierarchy;
