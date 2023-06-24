'use client';

import { useCallback, useMemo } from 'react';

import { LngLatBoundsLike, useMap } from 'react-map-gl';

import { useRecoilValue, useSetRecoilState } from 'recoil';

import { bboxAtom, tmpBboxAtom } from '@/store/index.';

import { Bbox } from '@/types/map';

import Map from '@/components/map';
import Controls from '@/components/map/controls';
import ZoomControl from '@/components/map/controls/zoom';
import { CustomMapProps } from '@/components/map/types';

const DEFAULT_PROPS: CustomMapProps = {
  id: 'default',
  initialViewState: {
    longitude: 0,
    latitude: 20,
    zoom: 2,
    pitch: 0,
    bearing: 0,
    bounds: [-122.519, 37.7045, -122.355, 37.829],
  },
  minZoom: 2,
  maxZoom: 10,
  // mapStyle: MAPBOX_STYLES.explore,
};

export default function MapContainer() {
  const { id, initialViewState, minZoom, maxZoom, mapStyle } = DEFAULT_PROPS;

  const { [id]: map } = useMap();

  const bbox = useRecoilValue(bboxAtom);
  const tmpBbox = useRecoilValue(tmpBboxAtom);

  const setBbox = useSetRecoilState(bboxAtom);
  const setTmpBbox = useSetRecoilState(tmpBboxAtom);

  const tmpBounds: CustomMapProps['bounds'] = useMemo(() => {
    if (tmpBbox) {
      return {
        bbox: tmpBbox,
        options: {
          padding: {
            top: 50,
            bottom: 50,
            // left: sidebarOpen ? 640 + 50 : 50,
            left: 50,
            right: 50,
          },
        },
      };
    }
  }, [tmpBbox]); // eslint-disable-line react-hooks/exhaustive-deps

  const handleViewState = useCallback(() => {
    if (map) {
      const b = map
        .getBounds()
        .toArray()
        .flat()
        .map((v: number) => {
          return parseFloat(v.toFixed(2));
        }) as Bbox;

      setBbox(b);
      setTmpBbox(null);
    }
  }, [map, setBbox, setTmpBbox]);

  return (
    <div className="h-screen w-screen">
      <Map
        id={id}
        initialViewState={{
          ...initialViewState,
          ...(bbox && {
            bounds: bbox as LngLatBoundsLike,
          }),
        }}
        bounds={tmpBounds}
        minZoom={minZoom}
        maxZoom={maxZoom}
        onMapViewStateChange={handleViewState}
      >
        {() => (
          <>
            <Controls className="absolute right-5 top-12 z-40 space-y-10 sm:right-6 sm:top-6">
              <ZoomControl />
            </Controls>
          </>
        )}
      </Map>
    </div>
  );
}