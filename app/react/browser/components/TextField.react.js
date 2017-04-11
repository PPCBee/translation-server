import Radium from 'radium';
import React, { PropTypes as RPT } from 'react';

import handleEvent from './handleEvent';
import { colors } from '../globals';

@Radium
export default class TextField extends React.PureComponent {

  static propTypes = {
    name: RPT.string.isRequired,
    onBlur: RPT.func.isRequired,
    onChange: RPT.func.isRequired,
    onFocus: RPT.func.isRequired,
    placeholder: RPT.string,
    style: React.PropTypes.shape({}),
    type: RPT.string.isRequired,
    value: RPT.string
  };

  static defaultProps = {
    optional: null,
    type: 'text',
    placeholder: 'Enter your text',
    style: {},
    value: ''
  };

  render() {
    const { name, placeholder, value, type, style, onChange, onBlur, onFocus } = this.props;
    return (
      <div style={styles.wrapper}>
        <input
          id={name}
          key="input"
          name={name}
          onBlur={handleEvent.bind(null, name, onBlur)}
          onChange={handleEvent.bind(null, name, onChange)}
          onFocus={handleEvent.bind(null, name, onFocus)}
          placeholder={placeholder}
          style={[
            styles.inputBase,
            style
          ]}
          type={type}
          value={value}
        />
      </div>
    );
  }
}

const styles = {
  wrapper: {
    backgroundColor: colors.lightGrey,
    borderColor: colors.inputBorder,
    borderStyle: 'solid',
    borderWidth: '1px',
    display: 'inline-block',
    height: '35px',
    marginLeft: '10%',
    padding: '0px 20px 0px 20px',
    verticalAlign: 'middle',
    ':focus': {
      borderColor: colors.primary
    }
  },

  inputBase: {
    backgroundColor: colors.lightGrey,
    borderStyle: 'none',
    color: colors.inputColor,
    height: '20px',
    fontSize: '14px',
    fontWeight: '300',
    width: '250px',
    verticalAlign: '-webkit-baseline-middle',
    ':focus': {
      outline: 'none'
    }
  }
};