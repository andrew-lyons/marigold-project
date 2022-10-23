<template>
    <div>
        <MainHeader />

        <Transition>
            <div v-if="loading" class="loader">
                <div class="clock-loader"></div>
            </div>

            <div v-else class="blog">
                <div class="blog-posts">
                    <div class="blog-posts-article" v-for="post, idx in posts" :key="idx+post">
                        <a @click="redirect(post.slug)" class="blog-posts-article-title" v-html="post.title"></a>

                        <a @click="redirectDate(post.date)" class="blog-posts-article-meta">{{ post.date }}</a>
                        <a @click="redirect(post.slug, true)" class="blog-posts-article-meta">Leave a comment</a>

                        <a @click="redirect(post.slug)"><img class="blog-posts-article-featured" :src="post.featured_image" alt=""></a>

                        <a @click="redirect(post.slug)" class="blog-posts-article-blurb" v-html="post.excerpt"></a>

                        <div class="blog-posts-article-links">
                            <a @click="redirect(post.slug)" class="blog-posts-article-links-href">Read more</a>

                            <div class="blog-posts-article-links-tags">
                                <a @click="redirectTags(tag.name)" v-for="tag, tagIdx in post.tags"
                                    :key="tag+tagIdx+'f'+idx">
                                    {{ tag.name }}
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="blog-sidebar">
                    <div ref="filterBtn" class="blog-sidebar-filterdrop">
                        <button v-if="isMobile" @click="animateFilterHeight()">
                            <h3>Post Filters</h3>
                        </button>

                        <div v-if="numPages.length > 1" class="blog-pagination">
                            <button @click="prevPage()" :disabled="curPage === 0"><img src="../../static/left-arrow.svg" alt=""></button>
                            <button @click="changePagination(idx+1)" v-for="page, idx in numPages" :key="'f'+idx+'0d'">{{ idx + 1 }}</button>
                            <button @click="nextPage()" :disabled="curPage === numPages.length-1"><img src="../../static/right-arrow.svg" alt=""></button>
                        </div>

                        <div class="blog-sidebar-category">
                            <h3>Date</h3>
    
                            <a @click="redirectDate(date)" v-for="date, dateIdx in dates" :key="date+dateIdx">{{ date }}</a>
                        </div>
    
                        <div class="blog-sidebar-category">
                            <h3>Categories</h3>
    
                            <a @click="redirectTags(tag)" v-for="tag, tagIdx in tags" :key="tag+tagIdx">{{ tag }}</a>
                        </div>
                    </div>
                </div>
            </div>
        </Transition>

        <MainFooter />
    </div>
</template>
  
<script lang="ts">
// import router from '@/router';

import { computed, defineComponent, onMounted, Ref, ref } from 'vue';
import MainHeader from '~/components/MainHeader.vue';

export default defineComponent({
    name: 'BlogView',
    components: {
        MainHeader
    },
    setup() {
        const wp = 'https://public-api.wordpress.com/rest/v1.1/sites/micaylalyons.wordpress.com';
        const loading = ref(true);
        const allPosts = ref([] as any);
        const numPages: Ref<undefined[]> = ref([]);
        const windowWidth = ref(1440);
        const curPage = ref(0);
        const paginationEnd = ref(6);
        const filterBtn: Ref<any> = ref(null);

        fetch(`${wp}/posts?number=100`)
            .then(response => response.json())
            .then(data => {
                allPosts.value = data.posts.filter((post: any) => Object.keys(post.categories).includes('blog-post'))
                numPages.value = Array.from(Array(Math.ceil(allPosts.value.length / 6)))
                loading.value = false;
            });

        const posts = computed(() => {
            const start = curPage.value * paginationEnd.value;

            return allPosts.value.map((post: any) => {
                post.date = new Date(post.date).toLocaleString('default', { month: 'long', day: 'numeric', year: 'numeric' });
                post.excerpt = post.excerpt.replaceAll('[', '').replaceAll(']', '');
                post.featured_image = post.featured_image ? post.featured_image : "../../static/marigold_bg.jpg"
                return post
            }).slice(start, start + paginationEnd.value);
        });

        const dates = computed(() => {
            const postDates = new Set(allPosts.value.map((post: any) => {
                const splitDate = post.date.split(' ');
                return `${splitDate[0]} ${splitDate[2]}`;
            }));

            return postDates;
        });

        const tags = computed(() => {
            return new Set(allPosts.value.map((post: any) => {
                const tagsValues = Object.values(post.tags);

                if (tagsValues) {
                    return tagsValues.map((tag: any) => tag.name);
                }
            }).flat());
        });

        const isMobile = computed(() => {
            return windowWidth.value <= 1024;
        });

        const changePagination = (page: number) => {
            curPage.value = page-1;
        }

        const nextPage = () => {
            if (curPage.value === numPages.value.length-1) return
            curPage.value += 1;
        }

        const prevPage = () => {
            if (curPage.value === 0) return
            curPage.value -= 1;
        }

        const redirect = (slug: string, commentSection = false) => {
            window.location.href = `/blog/detail${commentSection ? '#comments' : ''}?slug=${slug}`;
        }

        const redirectDate = (date: string) => {
            const toDate = new Date(date).toLocaleString('default', { month: 'long', year: 'numeric' });
            window.location.href = `/blog/filter?datefilter=${toDate}`;
        }

        const redirectTags = (tag: string) => {
            window.location.href = `/blog/filter?categoryfilter=${tag}`;
        }

        const animateFilterHeight = () => {
            const height = parseInt(getComputedStyle(filterBtn.value).height, 10);
            if (height <= 56) {
                filterBtn.value.classList.add('opened');
                filterBtn.value.style.height = filterBtn.value.scrollHeight + 'px';
            }
            else {
                filterBtn.value.classList.remove('opened');
                filterBtn.value.style.height = '56px';
            }
        }

        onMounted(() => {
            windowWidth.value = window.innerWidth;
            window.addEventListener('resize', () => windowWidth.value = window.innerWidth)
        });

        return {
            posts,
            dates,
            tags,
            loading,
            curPage,
            paginationEnd,
            numPages,

            redirect,
            redirectDate,
            redirectTags,
            changePagination,
            prevPage,
            nextPage,
            animateFilterHeight,
            filterBtn,
            isMobile
        }
    }
});
</script>

<style lang="scss">

.v-enter-active,
.v-leave-active {
    transition: opacity 0.125s ease;
}

.v-enter-from,
.v-leave-to {
    opacity: 0;
}

.loader {
    display: flex;
    justify-content: center;
    height: 80vh;
    width: 100vw;
    padding-top: 100px;

    .clock-loader {
        --clock-color: var(--primary);
        --clock-width: 4rem;
        --clock-radius: calc(var(--clock-width) / 2);
        --clock-minute-length: calc(var(--clock-width) * 0.4);
        --clock-hour-length: calc(var(--clock-width) * 0.2);
        --clock-thickness: 0.2rem;

        position: relative;
        display: flex;
        justify-content: center;
        align-items: center;
        width: var(--clock-width);
        height: var(--clock-width);
        border: 2px solid var(--clock-color);
        border-radius: 50%;

        &::before,
        &::after {
            position: absolute;
            content: "";
            top: calc(var(--clock-radius) * 0.25);
            width: var(--clock-thickness);
            background: var(--clock-color);
            border-radius: 10px;
            transform-origin: center calc(100% - calc(var(--clock-thickness) / 2));
            animation: spin infinite linear;
        }

        &::before {
            height: var(--clock-minute-length);
            animation-duration: 2s;
        }

        &::after {
            top: calc(var(--clock-radius) * 0.25 + var(--clock-hour-length));
            height: var(--clock-hour-length);
            animation-duration: 15s;
        }
    }
}

@keyframes spin {
    to {
        transform: rotate(1turn);
    }
}

.blog {
    display: flex;
    flex-wrap: wrap;
    margin: 0 auto;
    max-width: 1140px;
    width: var(--width);
    margin-bottom: 70px;
    margin-top: 40px;

    a {
        cursor: pointer;
    }

    h2 {
        font-size: 64px;
        line-height: 72px;
        font-weight: 100;
        margin: 36px 0 64px;
        width: 100%;
        cursor: default;
    }

    &-posts {
        width: 68.4%;
        padding-right: 48px;

        @media screen and (max-width: 1024px) {
            width: 100%;
            order: 3;
            padding: 0;
        }

        &-article {
            background: var(--white);
            padding: 40px;
            text-align: left;
            margin-bottom: 24px;

            @media screen and (max-width: 600px) {
                padding: 20px;
            }

            &-title {
                display: flex;
                font-family: 'Montserrat', sans-serif;
                font-size: 40px;
                line-height: 56px;
                font-weight: 200;
                text-transform: none;
                margin: 0;
                cursor: pointer;
                text-align: left;
                width: 100%;
                opacity: 1;
                transition: opacity 0.5s;
                text-decoration: none;

                &:hover {
                    opacity: 0.5;
                }
            }

            &-meta {
                display: inline-flex;
                font-family: Lato, sans-serif;
                font-size: 8px;
                font-weight: 500;
                letter-spacing: 1px;
                margin: 0 16px 20px 0;
                text-transform: uppercase;
                cursor: pointer;
                opacity: 1;
                transition: opacity 0.5s;

                &:hover {
                    opacity: 0.5;
                }
            }

            &-featured {
                width: 100%;
                height: auto;
            }

            &-blurb {
                margin: 14px 0 28px;
                padding: 0;
                letter-spacing: 2px;
                font-weight: 300;
                line-height: 1.625;
            }

            &-links {
                display: flex;
                flex-wrap: wrap;

                >a {
                    display: inline-flex;
                    font-family: "Montserrat", Sans-serif;
                    font-size: 11px;
                    font-weight: 400;
                    text-transform: uppercase;
                    fill: var(--white);
                    background-color: var(--white);
                    border-style: solid;
                    border-width: 1px 1px 1px 1px;
                    border-color: var(--primary-light);
                    border-radius: 0px 0px 0px 0px;
                    padding: 10px 20px;
                    margin-bottom: 24px;
                    cursor: pointer;
                    text-decoration: none;
                    letter-spacing: 2px;
                    transition: background-color 0.5s, color 0.5s;

                    &:hover {
                        background-color: var(--primary-light);
                        color: var(--white);
                    }
                }

                &-tags {
                    display: flex;
                    width: 100%;

                    a {
                        background-color: none;
                        padding: 0;
                        margin-right: 16px;
                        text-decoration: none;
                        font-size: 11px;
                        letter-spacing: 1px;
                        opacity: 1;
                        transition: opacity 0.5s;

                        &:hover {
                            opacity: 0.5;
                        }
                    }
                }
            }
        }
    }

    &-sidebar {
        position: sticky;
        top: 75px;
        width: 31.6%;
        height: 100%;

        @media screen and (max-width: 1024px) {
            width: calc(100% + 8px);
            left: -4px;
            order: 1;
            padding: 24px 0;
            background-color: #f0e9e8;
            top: 52px;
        }

        &-filterdrop {
            width: 100%;

            transition: height 0.5s;

            @media screen and (max-width: 1024px) {
                height: 56px;
                overflow: hidden;
            }

            &.opened {
                > button {
                    background: var(--primary-light);
                    
                    h3 {
                        color: var(--white);
                    }
                }
            }

            > button {
                width: 100%;
                background: var(--white);
                border: none;
                padding: 16px 0;
                margin-bottom: 16px;

                h3 {
                    font-family: 'Montserrat';
                    font-weight: 200;
                    font-size: 24px;
                    line-height: 24px;
                    margin: 0;
                }
            }

            @media screen and (max-width: 1024px) {
                display: flex;
                flex-wrap: wrap;
                justify-content: space-between;
                align-items: flex-start;
            }
        }

        &-category {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 24px;
            cursor: default;

            @media screen and (max-width: 1024px) {
                width: 45%;
            }

            h3 {
                font-size: 15px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 3px;
                margin-top: 0;
            }

            a {
                border-bottom: 0;
                margin-bottom: 10px;
                padding-bottom: 10px;
                padding: 10px;
                text-align: center;
                background: var(--white);
                text-transform: uppercase;
                letter-spacing: 5px;
                font-weight: 800;
                font-size: 12px;
                line-height: 16px;
                padding: 10px;
                width: 100%;
                text-decoration: none;
                transition: background-color 0.5s, color 0.5s;

                &:hover {
                    background-color: var(--primary-light);
                    color: var(--white);
                }
            }
        }
    }

    &-pagination {
        display: flex;
        justify-content: center;
        padding: 20px 0 40px;
        width: 100%;

        @media screen and (max-width: 1024px) {
            order: 2;
        }

        button {
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0 16px 0 0;
            padding: 0;
            background: none;
            border: none;
            font-size: 20px;
            line-height: 20px;
            height: 20px;
            width: 20px;
            cursor: pointer;

            &:last-child {
                margin: 0;
            }

            img {
                width: 100%;
                height: 100%;
            }

            &:disabled {
                opacity: 0.5;
                pointer-events: none;
                cursor: default;
            }
        }
    }
}
</style>
  