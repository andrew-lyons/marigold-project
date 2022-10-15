<template>
    <div>
        <client-only>
            <MainHeader />
    
            <main>
                <div class="product">
                    <h2>{{ post.title }}</h2>
                    <img :src="post.featured_image" alt="">
                </div>
    
                <div class="checkout">
                    <div class="checkout-form">
                        <div class="checkout-form-group checkout-form-group-wrapped">
                            <div @click="shippingChange(false)">
                                <input checked type="radio" name="shippingorlocal" ref="formIsLocalPickup">
                                <p>I'll pick my ornament up locally</p>
                            </div>
    
                            <div @click="shippingChange(true)">
                                <input type="radio" name="shippingorlocal" ref="formIsShipping">
                                <p>I'll need my ornament shipped to me</p>
                            </div>
                        </div>
    
                        <div class="checkout-form-group">
                            <input :class="formNameErr ? 'checkout-form-group-error' : ''" type="text" v-model="formName" placeholder="Your name (required)">
                            <input :class="formEmailErr ? 'checkout-form-group-error' : ''" type="text" v-model="formEmail" placeholder="Your email (required)">
                        </div>
    
                        <div v-if="displayAddressForm" class="checkout-form-group">
                            <input :class="formShippingAddressErr ? 'checkout-form-group-error' : ''" type="text" v-model="formShippingAddress" placeholder="Full shipping address (required)">
                        </div>
    
                        <div class="checkout-form-group">
                            <input type="text" v-model="babyFamName" placeholder="Baby/Family name">
                            <input type="text" v-model="ornamentDates" placeholder="Date(s) for ornament">
                        </div>
    
                        <div class="checkout-form-group">
                            <textarea
                                type="text"
                                v-model="formSpecialRequests"
                                placeholder="Special requests (i.e. godparents instead of grandparents, multiple baby names, etc.)">
                            </textarea>
                        </div>
    
                        <div class="checkout-form-group">
                            <input
                                v-model="dollarAmount"
                                type="range"
                                id="cowbell"
                                name="cowbell"
                                :min="displayAddressForm ? 12 : 10"
                                :max="displayAddressForm ? 102 : 100"
                                step="10"
                            >
                            <p class="amount">$ {{ dollarAmount }}</p>
                        </div>
                    </div>
    
                    <stripe-element-card ref="elementRef" :pk="publishableKey" @token="tokenCreated" />
    
                    <div class="checkout-form-submit">
                        <p>Thank you!</p>
    
                        <a @click="submit">Submit Payment</a>
                    </div>

                    <p class="stripe-charge-error" v-if="stripeChargeError" v-html="stripeChargeError"></p>
                </div>
            </main>
    
            <MainFooter />
        </client-only>
    </div>
</template>
    
<script lang="ts">
import { defineComponent, onMounted, Ref, ref } from 'vue';

export default defineComponent({
    name: 'ProductView',
    setup() {
        const wp = 'https://public-api.wordpress.com/rest/v1.1/sites/micaylalyons.wordpress.com';

        const post = ref({} as any);

        const elementRef: Ref<any> = ref(null);
        const formIsLocalPickup: Ref<any> = ref(null);
        const formIsShipping: Ref<any> = ref(null);
        const displayAddressForm = ref(false);

        const formName = ref('');
        const formNameErr = ref('');

        const formEmail = ref('');
        const formEmailErr = ref('');

        const formShippingAddress = ref('');
        const formShippingAddressErr = ref('');

        const babyFamName = ref('');
        const ornamentDates = ref('');
        const formSpecialRequests = ref('');
        const dollarAmount = ref(20);

        const stripeChargeError = ref('');

        const publishableKey = 'pk_test_51LsxDgCGzu6CcAA05tXeRA7g5SzzN1l9LnxUu8iCSZCGAYfaDmDYc8AEw6cuEwoWNbplSG2YBUVIE3fL5EqgYy4U002R4RetiP';

        onMounted(() => {
            const slug = new URLSearchParams(location.search).get('slug');
            fetch(`${wp}/posts/slug:${slug}`)
                .then(response => response.json())
                .then(data => post.value = data);
        })

        const submit = () => {
            if (validateForm()) {
                elementRef.value.submit();
            }
        };

        const validateForm = (): boolean => {
            if (!(/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formEmail.value))) {
                formEmailErr.value = 'Please include a valid email';
            }
            else {
                formEmailErr.value = '';
            }

            if (formName.value.length <= 0) {
                formNameErr.value = 'Please include your name';
            }
            else {
                formNameErr.value = '';
            }

            if (displayAddressForm.value && formShippingAddress.value.length <= 0) {
                formShippingAddressErr.value = 'Please include a shipping address';
            }
            else {
                formShippingAddressErr.value = '';
            }

            return !formEmailErr.value && !formNameErr.value && !formShippingAddressErr.value;
        }

        const tokenCreated = (token: any) => {
            const queryParams = new URLSearchParams();
            queryParams.set('formName', formName.value);
            queryParams.set('formEmail', formEmail.value);
            queryParams.set('babyFamName', babyFamName.value);
            queryParams.set('ornamentDates', ornamentDates.value);
            queryParams.set('formShippingAddress', formShippingAddress.value);
            queryParams.set('formSpecialRequests', formSpecialRequests.value);
            queryParams.set('amount', (dollarAmount.value * 100).toString());
            queryParams.set('token', token['id']);
            queryParams.set('ornament', post.value.title);

            fetch(`https://serverless-stripe-three.vercel.app/api/charge?${queryParams.toString()}`)
            .then(response => response.json())
            .then(data => {
                stripeChargeError.value = "";
                window.location.href = '/store/thankyou';
            })
            .catch(err => {
                console.log('woops', err);

                stripeChargeError.value = "There was an error processing your payment. Please try again or email us <a href='mailto:micayla@themarigoldproject.com'>here</a>";
            });
        }

        const shippingChange = (currentStat: boolean) => {
            if (currentStat) {
                formIsShipping.value.checked = true;
                displayAddressForm.value = true;

                if (dollarAmount.value % 10 === 0) {
                    dollarAmount.value = dollarAmount.value + 2;
                }
            }
            else {
                formIsLocalPickup.value.checked = true;
                displayAddressForm.value = false;

                if (dollarAmount.value % 10 !== 0) {
                    dollarAmount.value = dollarAmount.value - 2;
                }
            }
        }

        return {
            publishableKey,
            elementRef,
            formIsLocalPickup,
            formIsShipping,
            displayAddressForm,

            post,
            dollarAmount,
            ornamentDates,
            babyFamName,
            formShippingAddress,
            formName,
            formEmail,
            formSpecialRequests,

            formNameErr,
            formEmailErr,
            formShippingAddressErr,
            stripeChargeError,

            submit,
            shippingChange,
            tokenCreated
        }
    }
});
</script>

<style lang="scss" scoped>
// range overrides
input[type=range] {
    -webkit-appearance: none;
    /* Hides the slider so that custom slider can be made */
    width: 100%;
    /* Specific width is required for Firefox. */
    background: transparent;
    /* Otherwise white in Chrome */
}

input[type=range]::-webkit-slider-thumb {
    -webkit-appearance: none;
}

input[type=range]:focus {
    outline: none;
    /* Removes the blue border. You should probably do some kind of focus styling for accessibility reasons though. */
}

input[type=range]::-ms-track {
    width: 100%;
    cursor: pointer;

    /* Hides the slider so custom styles can be added */
    background: transparent;
    border-color: transparent;
    color: transparent;
}

/* Special styling for WebKit/Blink */
input[type=range]::-webkit-slider-thumb {
    -webkit-appearance: none;
    border: 1px solid #000000;
    height: 36px;
    width: 16px;
    border-radius: 3px;
    background: #ffffff;
    cursor: pointer;
    margin-top: -14px;
    /* You need to specify a margin in Chrome, but in Firefox and IE it is automatic */
    /* Add cool effects to your sliders! */
}

/* All the same stuff for Firefox */
input[type=range]::-moz-range-thumb {
    border: 1px solid #000000;
    height: 36px;
    width: 16px;
    border-radius: 3px;
    background: #ffffff;
    cursor: pointer;
}

/* All the same stuff for IE */
input[type=range]::-ms-thumb {
    border: 1px solid #000000;
    height: 36px;
    width: 16px;
    border-radius: 3px;
    background: #ffffff;
    cursor: pointer;
}

input[type=range]::-webkit-slider-runnable-track {
    width: 100%;
    height: 8.4px;
    cursor: pointer;
    box-shadow: 1px 1px 1px #000000, 0px 0px 1px #0d0d0d;
    background: #3071a9;
    border-radius: 1.3px;
    border: 0.2px solid #010101;
}

input[type=range]:focus::-webkit-slider-runnable-track {
    background: #367ebd;
}

input[type=range]::-moz-range-track {
    width: 100%;
    height: 8.4px;
    cursor: pointer;
    background: #3071a9;
    border-radius: 1.3px;
    border: 0.2px solid #010101;
}

input[type=range]::-ms-track {
    width: 100%;
    height: 8.4px;
    cursor: pointer;
    background: transparent;
    border-color: transparent;
    border-width: 16px 0;
    color: transparent;
}

input[type=range]::-ms-fill-lower {
    background: #2a6495;
    border: 0.2px solid #010101;
    border-radius: 2.6px;
}

input[type=range]:focus::-ms-fill-lower {
    background: #3071a9;
}

input[type=range]::-ms-fill-upper {
    background: #3071a9;
    border: 0.2px solid #010101;
    border-radius: 2.6px;
}

input[type=range]:focus::-ms-fill-upper {
    background: #367ebd;
}

input[type=range] {
    margin: 16px 0;
}
</style>

<style lang="scss" scoped>
.stripe-charge-error {
    font-size: 24px;
    line-height: 32px;
    color: red;

    :deep(a) {
        text-decoration: underline;
        color: red;
        cursor: pointer;
    }
}

main {
    margin: 48px auto;

    :deep(#stripe-element-errors) {
        margin-top: 8px;
        text-align: left;
    }

    @media screen and (max-width: 768px) {
        flex-wrap: wrap;
    }

    .product {
        display: flex;
        height: 100%;
        width: 50%;
        flex-wrap: wrap;
        padding-right: 40px;
        justify-content: center;

        @media screen and (max-width: 768px) {
            width: 100%;
            padding: 0;
            margin-bottom: 24px;
        }

        h2 {
            font-weight: 300;
            font-size: 36px;
            margin-top: 0;
        }

        img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
        }

    }

    .checkout {
        width: 50%;

        @media screen and (max-width: 768px) {
            width: 100%;
        }

        input:not([type=range]),
        textarea {
            border: none;
            font-size: 16px;
        }

        textarea {
            width: 100%;
            height: 64px;
            font-family: 'Montserrat';
            padding: 8px 16px;

            @media screen and (max-width: 768px) {
                height: 84px;
            }

            &::placeholder {
                font-size: 16px;
                color: rgb(172, 183, 194);
            }
        }

        &-form {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;

            &-group {
                display: flex;
                width: 100%;
                margin-bottom: 16px;

                @media screen and (max-width: 600px) {
                    flex-wrap: wrap;
                }

                &-wrapped {
                    flex-wrap: wrap;

                    div {
                        display: flex;
                        align-items: center;
                        width: 100%;
                        cursor: pointer;
                    }
                }

                &-error {
                    border: 1px solid red !important;
                }

                input[type=text] {
                    width: 100%;
                    padding: 10px 16px;
                    height: 38px;
                    border-radius: 5px;

                    &::placeholder {
                        font-size: 16px;
                        color: rgb(172, 183, 194);
                    }

                    &:nth-child(2n) {
                        margin-left: 16px;

                        @media screen and (max-width: 600px) {
                            margin-left: 0;
                            margin-top: 16px;
                        }
                    }
                }

                p.amount {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    width: 100%;
                    font-size: 24px;
                    margin: 0;
                }
            }

            input[type=radio] {
                height: 16px;
                width: 16px;
                margin: 0;
                cursor: pointer;
            }

            p {
                margin: 0 0 0 8px;
                line-height: 24px;
                font-size: 14px;
            }

            &-submit {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 16px;

                p {
                    margin: 0;
                }

                a {
                    display: flex;
                    justify-content: center;
                    font-family: "Montserrat", Sans-serif;
                    font-size: 13px;
                    font-weight: 600;
                    text-transform: uppercase;
                    fill: var(--white);
                    background-color: var(--white);
                    border-style: solid;
                    border-width: 1px 1px 1px 1px;
                    border-color: var(--primary-light);
                    border-radius: 0px 0px 0px 0px;
                    padding: 15px 25px;
                    margin: 0;
                    cursor: pointer;
                    transition: background-color 0.5s, color 0.5s;
                    letter-spacing: 3.1px;
                    text-decoration: none;
                }
            }
        }
    }
}
</style>
    