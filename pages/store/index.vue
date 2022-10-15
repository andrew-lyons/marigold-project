<template>
    <div>
        <MainHeader />

        <main>
            <div class="store-hero">
                <h2>Marigold Project Store?</h2>
                <p>Perhaps here we explain what the deal is and why there are occasionally some items here.</p>
            </div>
    
            <div class="store-products">
                <div
                    class="store-products-item"
                    v-for="ornament, idx in posts"
                    :key="ornament+' l '+idx"
                    @click="redirect(ornament.slug)"
                >
                    <a class="store-products-item-image"><img :src="ornament.featured_image"></a>
                    <a><h3>{{ ornament.title }}</h3></a>
                </div>
            </div>
        </main>

        <MainFooter />
    </div>
</template>
    
<script lang="ts">
import { computed, defineComponent, ref } from 'vue';

export default defineComponent({
    name: 'StoreView',
    setup() {
        const wp = 'https://public-api.wordpress.com/rest/v1.1/sites/micaylalyons.wordpress.com';
        const loading = ref(true);
        const allPosts = ref([] as any);

        fetch(`${wp}/posts`)
            .then(response => response.json())
            .then(data => {
                allPosts.value = data.posts.filter((post: any) => Object.keys(post.categories).includes('ornament'))
                loading.value = false;

                console.log(allPosts);
            });

        const posts = computed(() => {
            return allPosts.value.map((post: any) => {
                post.featured_image = post.featured_image ? post.featured_image : "../../static/marigold_bg.jpg"
                return post
            });
        });

        const redirect = (slug: string) => {
            window.location.href = `/store/product?slug=${slug}`;
        }

        return {
            posts,
            loading,

            redirect
        }
    }
});
</script>

<style lang="scss" scoped>
main {
    margin-top: 24px;
    margin-bottom: 100px;
    flex-wrap: wrap;

    .store {
        &-hero {
            position: relative;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: center;
            width: 100%;

            h2 {
                width: 100%;
                font-size: 56px;
                line-height: 64px;
                font-weight: 200;
                z-index: 3;
                margin-bottom: 0;
            }

            p {
                font-size: 16px;
                line-height: 24px;
                font-weight: 400;
                letter-spacing: 2px;
            }
        }

        &-products {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-start;
            margin-top: 50px;
            width: 100%;

            &-item {
                padding: 20px;
                width: 19vw;
                background-color: var(--white);
                margin-bottom: 16px;
                border-radius: 6px;
                box-shadow: 0px 3px 5px 2px rgb(0 0 0 / 30%);
                margin-right: 1.04vw;
                cursor: pointer;
                transition: box-shadow 0.25s;

                &:hover {
                    box-shadow: 0px 3px 10px 5px rgb(0 0 0 / 30%);
                }

                &:nth-child(4n) {
                    margin-right: 0;
                }

                a {
                    display: flex;
                    justify-content: center;

                    &.image {
                        width: 17.36vw;
                        height: 17.36vw;
                    }
                }

                img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }

                h3 {
                    font-size: 1.66vw;
                    font-weight: 300;
                    margin: 12px 0;
                }
            }
        }
    }
}
</style>
    