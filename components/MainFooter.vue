<template>
    <footer>
        <div>
            <div class="column">
                <h4>The Marigold Project</h4>

                <p>In honor of Nora Marjorie and Baby Bean</p>
            </div>

            <div class="column logo">
                <img src="../static/marigold-project-logo.png" alt="">
            </div>

            <div class="column">
                <h4>Get In Touch</h4>
                <!-- <a href="mailto:mhupp21@gmail.com">
                    <font-awesome-icon icon="envelope" />
                </a>
                <a>
                    <font-awesome-icon icon="fa-brands fa-facebook" />
                </a>
                <a>
                    <font-awesome-icon icon="fa-brands fa-instagram" />
                </a> -->
            </div>
        </div>
    </footer>
</template>

<style lang="scss" scoped>
footer {
    position: relative;
    z-index: 1;
    background: var(--white);
    clear: both;
    border-top: 0;
    width: var(--width);
    margin: 0 auto;
    padding: 60px 0;
    max-width: 1140px;

    &:before {
        content: " ";
        display: block;
        position: absolute;
        top: 0;
        bottom: 0;
        width: 150vw;
        left: -25vw;
        right: -25vw;
        background-color: var(--white);
        box-shadow: 0 0 20px 15px var(--white);
        z-index: -1;
    }

    @media screen and (max-width: 768px) {
        margin-top: 70px;
    }

    >div {
        display: flex;
        justify-content: space-between;
        margin: 0 auto;

        @media screen and (max-width: 768px) {
            justify-content: flex-end;
            flex-wrap: wrap;
        }

        .column {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
            align-self: center;
            width: 33%;

            h4 {
                margin-bottom: 0;
                background: transparent;
                font-family: 'Montserrat', sans-serif;
                font-size: 15px;
                letter-spacing: 3px;
                font-weight: 600;
                text-align: center;
                text-transform: uppercase;
                padding: 12px 0px;
                width: 100%;
            }

            p {
                width: 100%;
            }

            a {
                cursor: pointer;
                margin-right: 12px;
                width: 25px;
                height: 25px;

                svg {
                    width: 100%;
                    height: 100%;

                    path {
                        transition: fill 0.25s;
                    }
                }

                &:last-child {
                    margin-right: 0;
                }

                &:hover {
                    svg {
                        path {
                            fill: grey;
                        }
                    }
                }
            }

            @media screen and (max-width: 768px) {
                width: 100%;
            }

            &.logo {
                img {
                    width: 100%;
                }

                @media screen and (max-width: 768px) {}
            }
        }
    }
}
</style>