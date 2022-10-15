<template>
    <div>
        <nav>
            <router-link :class="currentRoute === '/' ? 'active-route' : ''" to="/">Home</router-link>
            <router-link :class="currentRoute.includes('/about') ? 'active-route' : ''" to="/about">About</router-link>
            <router-link :class="currentRoute.includes('/blog') ? 'active-route' : ''" to="/blog">Blog</router-link>
            <router-link :class="currentRoute.includes('/store') ? 'active-route' : ''" to="/store">Store</router-link>
        </nav>
    
        <header>
            <a href="/">
                <h1>
                    The Marigold Project
                </h1>
            </a>
        </header>
    </div>
</template>

<script setup>
import { onMounted, ref } from 'vue';
const currentRoute = ref('');

onMounted(() => {
    currentRoute.value = location.href;
    console.log(currentRoute.value);
})
</script>

<style lang="scss" scoped>
a {
    cursor: pointer;
}
nav {
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 4;
    display: flex;
    justify-content: center;
    font-weight: 600;
    text-align: center;
    background: var(--white);
    text-transform: uppercase;
    letter-spacing: 5px;
    font-size: 12px;

    a {
        font-weight: 600;
        text-align: center;
        background: var(--white);
        text-transform: uppercase;
        letter-spacing: 5px;
        font-size: 12px;
        padding: 20px;
        text-decoration: none;

        @media screen and (max-width: 500px) {
            padding: 20px 12px;
            font-size: 10px;
        }
    }
}

header {
    @media screen and (max-width: 768px) {
        margin-top: 50px;
    }

    h1 {
        display: inline-block;
        font-size: 7.15vw;
        font-weight: 100;
        letter-spacing: 5px;
        line-height: 2;
        margin-bottom: 10px;
        font-family: 'Montserrat', sans-serif;
        cursor: default;

        @media screen and (min-width: 1441px) {
            font-size: 103px;
        }

        @media screen and (max-width: 600px) {
            font-size: 10.66vw;
            line-height: 1.15;
            margin-bottom: 16px;
            padding: 0 16px;
        }
    }
}
</style>