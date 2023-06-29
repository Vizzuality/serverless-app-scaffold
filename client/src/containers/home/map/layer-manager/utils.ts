/* eslint-disable @typescript-eslint/no-var-requires */

import { JSONConverter } from '@deck.gl/json/typed';

/**
 * *`setOpacity`*
 * Set opacity
 * @param {Number} o
 * @param {Number} base
 * @returns {Number} opacity
 */
type SetOpacityProps = { o: number; base: number };
export const setOpacity = ({ o = 1, base = 1 }: SetOpacityProps) => {
  return o * base;
};

type SetVisibilityProps = { v: boolean };
export const setVisibility = ({ v = true }: SetVisibilityProps) => {
  return v;
};

export const JSON_CONFIGURATION = {
  layers: Object.assign(
    //
    {},
    require('@deck.gl/layers'),
    require('@deck.gl/aggregation-layers')
  ),
  functions: {
    setOpacity,
    setVisibility,
  },
  constants: {},
  enumerations: {},
};

/**
 * *`getParams`*
 * Get params from params_config
 * @param {Object} params_config
 * @returns {Object} params
 *
 */
export type ParamConfig = {
  key: string;
  default: unknown;
};
export interface GetParamsProps {
  settings: Record<string, unknown>;
  params_config: ParamConfig[];
}
export const getParams = ({ params_config, settings = {} }: GetParamsProps) => {
  if (!params_config) {
    return {};
  }
  return params_config.reduce((acc, p) => {
    return {
      ...acc,
      [p.key]: settings[p.key] ?? p.default,
    };
  }, {});
};

/**
 * *`parseConfig`*
 * Parse config with params_config
 * @param {Object} config
 * @param {Object} params_config
 * @returns {Object} config
 *
 */
interface ParseConfigurationProps {
  config: unknown;
  params_config: unknown;
  settings: Record<string, unknown>;
}
export const parseConfig = <T>({ config, params_config, settings }: ParseConfigurationProps): T => {
  const JSON_CONVERTER = new JSONConverter({
    configuration: JSON_CONFIGURATION,
  });

  const pc = params_config as ParamConfig[];
  const params = getParams({ params_config: pc, settings });

  // Merge constants with config
  JSON_CONVERTER.mergeConfiguration({
    enumerations: {
      params,
    },
  });
  return JSON_CONVERTER.convert(config);
};