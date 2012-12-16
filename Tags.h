/*
 *
 * Created by Mete Ozguz on 2012-03
 * Copyright Mete Ozguz 2012
 *
 * http://www.meteozguz.com
 * meteo158@gmail.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#ifndef CIPHERTEXT_TAGS_H
#define CIPHERTEXT_TAGS_H

static const NSInteger Z_ORDER_LEVEL_TITLE = 15;
static const NSInteger Z_ORDER_MENU = 15;
static const NSInteger Z_ORDER_PLAYER = 10;
static const NSInteger Z_ORDER_HELPER_TEXT = 11;
static const NSInteger Z_ORDER_MINE = 0;
static const NSInteger Z_ORDER_BACKGROUND = -100;

enum{
    TAG_PLAYER = 31,
    TAG_PLAYER_PLAYERSPRITE,
    TAG_ABILITY_CROSS_PASS,
    TAG_NODE_DIFFICULTY_MENU,
    TAG_GAME_TITLE
};

//THEY ARE 40 LVL. DO NOT MISS TO ADD NEW ENUMS ACCORDINGLY!
enum{
    TAG_LVL0 = 100
};

enum{
    TAG_MENU_ITEM_CONTINUE = 140,
    
    TAG_ABILITY_MENU_ABILITY_0
};

#endif
