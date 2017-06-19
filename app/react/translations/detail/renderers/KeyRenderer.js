// @flow
import React from 'react';
import LabelLink from '../../../hierarchy/keys/LabelLink';

import type { LocationWithQuery } from '../../../types/locationTypes';


type PropTypes = {
  translationKey: string,
  location: LocationWithQuery
};

export default function KeyRenderer({ translationKey, location }: PropTypes) {
  const labels = translationKey.split('.');
  return (
    <div style={styles.wrapper}>
      {labels.map((label, i) => (
        <span key={labels.slice(0, i + 1)}>
          {i ? '.' : null}
          <LabelLink
            label={label}
            path={labels.slice(0, i + 1)}
            location={location}
          />
        </span>
      ))}
    </div>);
}

const styles = {
  wrapper: {
    padding: '10px 25px',
    minHeight: '40px',
    bboxShadow: '0 0 7px hsla(0, 0%, 0%, 0.1)',
    display: 'flex',
    alignItems: 'center'
  }
};
