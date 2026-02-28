import { Location } from '../protoDefinitions/tracker';
import { config } from '../server';

export const getRandomCoords = (
  xMin: number = config.uiDimensions!.minSize,
  xMax: number = config.uiDimensions!.maxSize,
  yMin: number = config.uiDimensions!.minSize,
  yMax: number = config.uiDimensions!.maxSize,
): Location => {
  return {
    x: Math.floor(Math.random() * (xMax - xMin) + xMin),
    y: Math.floor(Math.random() * (yMax - yMin) + yMin),
  };
};
