'use client';

import { useRecoilValue, useSetRecoilState } from 'recoil';

import { layersAtom } from '@/store';

import {
  DeckGlLayerListResponseDataItem,
  MapboxLayerListResponseDataItem,
} from '@/types/generated/strapi.schemas';

import { Switch } from '@/components/ui/switch';

export default function LayersItem({
  id,
  attributes,
}: Required<MapboxLayerListResponseDataItem> | Required<DeckGlLayerListResponseDataItem>) {
  const layers = useRecoilValue(layersAtom);
  const setLayers = useSetRecoilState(layersAtom);

  const handleLayerChange = () => {
    if (!id) return;
    // Toogle layers if they exist
    if (layers.includes(id)) {
      return setLayers(layers.filter((l) => l !== id));
    }

    // Add layers if they don't exist
    if (!layers.includes(id)) {
      return setLayers([...layers, id]);
    }
  };

  return (
    <li key={id} className="flex justify-between space-x-2.5">
      <h4>{attributes?.title}</h4>

      <Switch checked={layers.includes(id)} onCheckedChange={handleLayerChange} />
    </li>
  );
}