import { CaseReducer, PayloadAction } from '@reduxjs/toolkit';
import { getItemData, itemDurability } from '../helpers';
import { Items } from '../store/items';
import { Inventory, State } from '../typings';

export const setupInventoryReducer: CaseReducer<
  State,
  PayloadAction<{
    leftInventory?: Inventory;
    rightInventory?: Inventory;
  }>
> = (state, action) => {
  const { leftInventory, rightInventory } = action.payload;
  const curTime = Math.floor(Date.now() / 1000);

  if (leftInventory) {
    const isShop = leftInventory.type === 'shop';
    const actualSlots = isShop ? Object.keys(leftInventory.items).length : leftInventory.slots;

    state.leftInventory = {
      ...leftInventory,
      slots: actualSlots,
      items: Array.from(Array(actualSlots), (_, index) => {
        const item = isShop
          ? Object.values(leftInventory.items)[index] || { slot: index + 1 }
          : leftInventory.items[index + 1] || { slot: index + 1 };

        if (!item.name) return item;

        if (typeof Items[item.name] === 'undefined') {
          getItemData(item.name);
        }

        item.durability = itemDurability(item.metadata, curTime);
        return item;
      }),
    };
  }

  if (rightInventory) {
    const isShop = rightInventory.type === 'shop';
    const actualSlots = isShop ? Object.keys(rightInventory.items).length : rightInventory.slots;

    state.rightInventory = {
      ...rightInventory,
      slots: actualSlots,
      items: Array.from(Array(actualSlots), (_, index) => {
        const item = isShop
          ? Object.values(rightInventory.items)[index] || { slot: index + 1 }
          : rightInventory.items[index + 1] || { slot: index + 1 };

        if (!item.name) return item;

        if (typeof Items[item.name] === 'undefined') {
          getItemData(item.name);
        }

        item.durability = itemDurability(item.metadata, curTime);
        return item;
      }),
    };
  }

  if (leftInventory) {
    state.utilityInventory = {
      ...state.utilityInventory,
      id: leftInventory.id,
      type: leftInventory.type,
      items: Array.from(Array(9), (_, index) => {
        const item = Object.values(leftInventory.items).find((item) => item?.slot === index + 1) || {
          slot: index + 1,
        };

        if (!item.name) return item;

        if (typeof Items[item.name] === 'undefined') {
          getItemData(item.name);
        }

        item.durability = itemDurability(item.metadata, curTime);
        return item;
      }),
    };
  }

  state.shiftPressed = false;
  state.isBusy = false;
};
