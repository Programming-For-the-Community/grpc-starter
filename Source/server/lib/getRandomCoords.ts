import { Location } from '../protoDefinitions/tracker';
import { uiDimensions } from '../config/serverConfig';

export const getRandomCoords = (xMin: number = uiDimensions.minSize, xMax: number = uiDimensions.maxSize, yMin: number = uiDimensions.minSize, yMax: number = uiDimensions.maxSize): Location => {
  return {
    x: Math.floor(Math.random() * (xMin - xMax) + xMin),
    y: Math.floor(Math.random() * (yMin - yMax) + yMin),
  };
};
