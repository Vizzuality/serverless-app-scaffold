import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { useMap } from 'react-map-gl';

import { useRecoilValue } from 'recoil';

import { format } from '@/lib/utils/formats';

import { layersInteractiveIdsAtom, popupAtom } from '@/store';

import { useGetLayersId } from '@/types/generated/layer';
import { LayerTyped } from '@/types/layers';

import ContentLoader from '@/components/ui/loader';

export interface PopupItemProps {
  id: number;
}
const PopupItem = ({ id }: PopupItemProps) => {
  const [rendered, setRendered] = useState(false);
  const DATA_REF = useRef<Record<string, unknown> | null>(null);

  const { default: map } = useMap();

  const popup = useRecoilValue(popupAtom);
  const layersInteractiveIds = useRecoilValue(layersInteractiveIdsAtom);

  const { data, isFetching, isFetched, isError, isPlaceholderData } = useGetLayersId(id);

  const attributes = data?.data?.attributes as LayerTyped;
  const source = attributes.config.source;
  const click = attributes.interaction_config.events.find((ev) => ev.type === 'click');

  const DATA = useMemo(() => {
    if (source.type === 'vector' && rendered) {
      const query = map?.queryRenderedFeatures(popup?.point, {
        layers: layersInteractiveIds,
      });

      const d = query?.find((d) => {
        return d.source === source?.id;
      })?.properties;

      if (d) {
        DATA_REF.current = d;
        return DATA_REF.current;
      }
    }

    return DATA_REF.current;
  }, [popup, source, layersInteractiveIds, map, rendered]);

  // handle renderer
  const handleMapRender = useCallback(() => {
    setRendered(!!map?.loaded() && !!map?.areTilesLoaded());
  }, [map]);

  useEffect(() => {
    map?.on('render', handleMapRender);

    return () => {
      map?.off('render', handleMapRender);
    };
  }, [map, handleMapRender]);

  return (
    <ContentLoader
      data={data?.data}
      isFetching={isFetching || (!rendered && !DATA_REF.current)}
      isFetched={isFetched && (rendered || !!DATA_REF.current)}
      isError={isError}
      isPlaceholderData={isPlaceholderData}
      skeletonClassName="h-20 w-[250px]"
    >
      <div className="space-y-3">
        <h3 className="text-lg font-semibold">{attributes.title}</h3>
        <dl className="space-y-2">
          {click &&
            !!DATA &&
            click.values.map((v) => {
              return (
                <div key={v.key}>
                  <dt className="text-xs font-semibold uppercase underline">{v.label || v.key}:</dt>
                  <dd>
                    {format({
                      id: v.format?.id,
                      value: DATA[v.key],
                      options: v.format?.options,
                    })}
                  </dd>
                </div>
              );
            })}
        </dl>
      </div>
    </ContentLoader>
  );
};

export default PopupItem;
