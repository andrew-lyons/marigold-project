<template>
	<main>
		<svg-map :map="UnitedStates" />
	</main>
</template>

<script>
import UnitedStates from '@/static/usa.json';
import { SvgMap } from "vue-svg-map";
import { defineComponent } from 'vue';

export default defineComponent({
	name: "MyMap",
	components: {
		SvgMap
	},
	setup() {
		return {
			UnitedStates
		}
	}
});
</script>

<style lang="scss" scoped>
main {
	:deep() {
		.svg-map {
			width: 100%;
			height: auto;
			stroke: #666;
			stroke-width: 1;
			stroke-linecap: round;
			stroke-linejoin: round;

			&__location {
				fill: #a1d99b;
				cursor: pointer;
		
				&:focus,
				&:hover {
					fill: #b8e2b3;
					outline: 0;
				}
		
				&[aria-checked="true"] {
					fill: #f4bc44;
				}
			}
		}
	}
}
</style>
